# Start from the official Microsoft Playwright image with Python
FROM mcr.microsoft.com/playwright/python:v1.53.0

# Set the working directory inside the container to /app
WORKDIR /app

# Copy your local files (app.py, requirements.txt) into the container
COPY . .

# Install all dependencies from the requirements.txt file in a single step
RUN pip install -r requirements.txt

# Tell Render that the app will listen on port 10000
EXPOSE 10000

# The command to run your Flask app with Gunicorn
CMD ["gunicorn", "--workers", "1", "--threads", "8", "--timeout", "0", "--bind", "0.0.0.0:10000", "app:app"]
