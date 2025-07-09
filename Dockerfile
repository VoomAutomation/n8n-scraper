# Start from the official Microsoft Playwright image with Python
FROM mcr.microsoft.com/playwright/python:v1.53.0

# Set the working directory inside the container to /app
WORKDIR /app

# Copy your local files (app.py) into the container's working directory
COPY . .

# Install Flask and Gunicorn. Playwright is already in the base image.
RUN pip install flask gunicorn

# Tell Render that the app will listen on port 10000
EXPOSE 10000

# The command to run your Flask app with Gunicorn
# --bind 0.0.0.0 is crucial to make it accessible
# --timeout 0 is to prevent long scraping requests from being cancelled
CMD ["gunicorn", "--workers", "1", "--threads", "8", "--timeout", "0", "--bind", "0.0.0.0:10000", "app:app"]
