# Use Python 3.11 slim image for better performance
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv for faster dependency management
RUN pip install uv

# Copy dependency files first for better Docker layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen

# Copy the rest of the application
COPY . .

# Expose the port that Railway will assign (Railway uses PORT env var)
EXPOSE $PORT

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8000

# Add uv's virtual environment to PATH
ENV PATH="/app/.venv/bin:$PATH"

# Command to run the application
CMD ["python", "main.py"]