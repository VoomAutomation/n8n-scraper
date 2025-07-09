import asyncio
from flask import Flask, request, jsonify
from playwright.async_api import async_playwright

app = Flask(__name__)

async def get_page_html(firm_slug):
    url = f"https://architizer.com/firms/{firm_slug}"
    try:
        async with async_playwright() as p:
            # Add --no-sandbox argument for Render's environment
            browser = await p.chromium.launch(headless=True, args=["--no-sandbox"])
            page = await browser.new_page()
            await page.goto(url, timeout=60000)
            await page.wait_for_selector("a.profile-website, a:has(span.icon.other)", timeout=60000)
            html_content = await page.content()
            await browser.close()
            return html_content
    except Exception as e:
        print(f"Scraping failed for slug {firm_slug}: {e}")
        return None

@app.route('/scrape', methods=['POST'])
async def scrape_firm():
    data = request.get_json()
    if not data or 'slug' not in data:
        return jsonify({"error": "Missing 'slug' in request body"}), 400
    slug = data['slug']
    html_result = await get_page_html(slug)
    if html_result:
        return jsonify({"html": html_result})
    else:
        return jsonify({"error": f"Failed to scrape page for slug: {slug}"}), 500
