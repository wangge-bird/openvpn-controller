FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openvpn \
    easy-rsa \
    iptables \
    curl \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ ./src/
COPY config/ ./config/

# Create necessary directories
RUN mkdir -p /app/data /app/logs /etc/openvpn/ccd /etc/openvpn/client-configs

# Copy OpenVPN configuration template
COPY openvpn.conf.template /etc/openvpn/server.conf.template

# Set permissions
RUN chmod 700 /etc/openvpn
RUN chmod 600 /etc/openvpn/*.crt /etc/openvpn/*.key 2>/dev/null || true

# Create non-root user
RUN useradd -m -u 1000 openvpn-admin && \
    chown -R openvpn-admin:openvpn-admin /app

USER openvpn-admin

# Expose ports
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run application
CMD ["gunicorn", "-c", "gunicorn.conf.py", "src.main:run"]