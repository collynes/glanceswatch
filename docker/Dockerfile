# Multi-stage build for GlanceWatch

# Build Python dependencies
FROM python:3.11-slim as python-builder

WORKDIR /build

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Final image
FROM python:3.11-slim

# Create non-root user
RUN useradd -m -u 1000 glancewatch && \
    mkdir -p /var/lib/glancewatch && \
    chown -R glancewatch:glancewatch /var/lib/glancewatch

WORKDIR /app

# Copy installed packages from builder
COPY --from=python-builder /root/.local /home/glancewatch/.local

# Copy application code and simple UI
COPY app ./app
COPY ui/index.html ./ui/index.html

# Set environment
ENV PATH=/home/glancewatch/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

# Switch to non-root user
USER glancewatch

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:8000/health').raise_for_status()"

# Expose port
EXPOSE 8000

# Run application
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
