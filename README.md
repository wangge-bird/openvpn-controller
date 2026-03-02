# OpenVPN Controller 🚀

A comprehensive OpenVPN management system with REST API, web interface, and automated deployment.

## Features ✨

- **RESTful API** - Complete OpenAPI 3.0.0 specification
- **JWT Authentication** - Secure token-based authentication
- **Configuration Management** - Dynamic VPN configuration
- **Access Control** - Fine-grained ACL management
- **Service Monitoring** - Real-time status and metrics
- **Web Interface** - Modern web-based management
- **Docker Support** - Containerized deployment
- **High Availability** - Production-ready architecture

## Quick Start 🚀

### One-Click Deployment

```bash
# Ubuntu/Debian
wget https://raw.githubusercontent.com/your-username/openvpn-controller/main/scripts/install.sh
sudo bash install.sh

# CentOS/RHEL
curl -O https://raw.githubusercontent.com/your-username/openvpn-controller/main/scripts/install.sh
sudo bash install.sh
```

### Docker Deployment

```bash
# Clone repository
git clone https://github.com/your-username/openvpn-controller.git
cd openvpn-controller

# Build and run
docker-compose up -d

# Access the API
curl https://localhost/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"secret123"}'
```

## Documentation 📚

- [API Documentation](docs/api.md)
- [Deployment Guide](docs/deployment.md)
- [User Manual](docs/user-manual.md)
- [Architecture](docs/architecture.md)
- [Security Guide](docs/security.md)

## API Reference 🔧

### Authentication

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "secret123"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

### Configuration Management

```http
GET /api/v1/config
Authorization: Bearer YOUR_JWT_TOKEN

Response:
{
  "server_port": 1194,
  "protocol": "udp",
  "ip_pool_start": "10.8.0.10",
  "ip_pool_end": "10.8.0.250",
  "subnet_mask": "255.255.255.0",
  "push_routes": ["192.168.1.0 255.255.255.0"],
  "dns_servers": ["8.8.8.8", "8.8.4.4"]
}
```

### Access Control

```http
POST /api/v1/access-rules
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json

{
  "direction": "out",
  "action": "allow",
  "cidr": "0.0.0.0/0",
  "description": "Allow all outbound traffic"
}

Response:
{
  "id": "rule-001",
  "direction": "out",
  "action": "allow",
  "cidr": "0.0.0.0/0",
  "description": "Allow all outbound traffic"
}
```

## Architecture 🏗️

```
┌─────────────────┐
│   Web Browser   │
└────────┬────────┘
         │
┌────────▼────────┐
│    Nginx        │
│  (Reverse Proxy)│
└────────┬────────┘
         │
┌────────▼────────┐
│  OpenVPN        │
│  Controller API │
└────────┬────────┘
         │
┌────────▼────────┐
│  OpenVPN Server │
└─────────────────┘
```

## Monitoring 📊

- **Prometheus Metrics** - System and service metrics
- **Grafana Dashboards** - Visual monitoring
- **Log Aggregation** - Centralized logging
- **Alert Manager** - Automated alerts

## Security 🔒

- **JWT Authentication** - Secure token-based auth
- **SSL/TLS** - Encrypted communications
- **Fail2Ban Integration** - Brute force protection
- **Firewall Configuration** - Network security
- **Access Control** - Fine-grained permissions
- **Audit Logging** - Security auditing

## Development 💻

### Prerequisites

- Python 3.8+
- Docker & Docker Compose
- OpenVPN
- Node.js (for frontend)

### Local Development

```bash
# Clone repository
git clone https://github.com/your-username/openvpn-controller.git
cd openvpn-controller

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run tests
python -m pytest tests/ -v

# Start development server
python src/main.py
```

### Code Style

```bash
# Format code
black src/ tests/

# Lint code
flake8 src/ tests/

# Type checking
mypy src/
```

## Deployment 🚀

### Production Deployment

```bash
# Use deployment script
./scripts/deploy.sh production

# Manual deployment
./scripts/setup-openvpn.sh config/server.conf
sudo systemctl enable openvpn-controller
sudo systemctl start openvpn-controller
```

### Cloud Deployment

- **AWS** - CloudFormation template
- **Azure** - ARM template
- **GCP** - Deployment Manager
- **DigitalOcean** - 1-Click App

## Contributing 🤝

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License 📄

MIT License - see [LICENSE](LICENSE) file for details

## Support 💬

- [GitHub Issues](https://github.com/your-username/openvpn-controller/issues)
- [Discussions](https://github.com/your-username/openvpn-controller/discussions)
- [Wiki](https://github.com/your-username/openvpn-controller/wiki)

## Changelog 📝

See [CHANGELOG.md](CHANGELOG.md) for release notes.

---

**Made with ❤️ by OpenVPN Controller Team**