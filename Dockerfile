cat << 'EOF' > Dockerfile
# Use a lightweight Python base image
FROM python:3.10-slim-buster

# Set the working directory inside the container
WORKDIR /src

# Copy requirements first to leverage Docker layer caching
COPY analytics/requirements.txt requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the analytics application code into the container
COPY analytics/ .

# Expose the application port
EXPOSE 5153

# Run the Flask application
CMD ["python", "app.py"]
EOF