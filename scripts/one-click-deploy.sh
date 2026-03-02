#!/bin/bash

# OpenVPN Controller One-Click Deployment Script
# This script deploys OpenVPN Controller to a fresh cloud server

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REPO_OWNER="your-username"
REPO_NAME="openvpn-controller"
BRANCH="main"
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/scripts/install.sh"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on supported cloud provider
check_cloud_provider() {
    log_info "Checking cloud provider..."
    
    if [ -f /etc/cloud-release ]; then
        CLOUD_PROVIDER=$(cat /etc/cloud-release | head -n1)
        log_info "Cloud provider detected: $CLOUD_PROVIDER"
    else
        log_warning "Could not detect cloud provider"
    fi
}

# Validate server requirements
validate_requirements() {
    log_info "Validating server requirements..."
    
    # Check OS
    if [ ! -f /etc/os-release ]; then
        log_error "Unsupported operating system"
        exit 1
    fi
    
    . /etc/os-release
    if [[ "$ID" != "ubuntu" && "$ID" != "debian" && "$ID" != "centos" ]]; then
        log_error "Unsupported OS: $ID"
        exit 1
    fi
    
    # Check resources
    CPU_CORES=$(nproc)
    MEMORY=$(free -g | awk '/^Mem:/{print $2}')
    
    if [ "$CPU_CORES" -lt 2 ]; then
        log_warning "Recommended CPU cores: 2, current: $CPU_CORES"
    fi
    
    if [ "$MEMORY" -lt 4 ]; then
        log_warning "Recommended memory: 4GB, current: ${MEMORY}GB"
    fi
    
    log_success "Server requirements validated"
}

# Setup domain
setup_domain() {
    log_info "Setting up domain..."
    
    # Get server IP
    SERVER_IP=$(curl -s ifconfig.me)
    
    echo ""
    echo "🔍 Your server IP is: $SERVER_IP"
    echo ""
    echo "📝 Please configure your DNS to point your domain to this IP"
    echo ""
    
    read -p "Enter your domain name (e.g., vpn.example.com): " DOMAIN
    
    if [ -z "$DOMAIN" ]; then
        log_error "Domain name is required"
        exit 1
    fi
    
    # Validate domain resolves to this server
    DOMAIN_IP=$(dig +short $DOMAIN 2>/dev/null || echo "")
    
    if [ -n "$DOMAIN_IP" ] && [ "$DOMAIN_IP" != "$SERVER_IP" ]; then
        log_warning "Domain $DOMAIN resolves to $DOMAIN_IP, but server IP is $SERVER_IP"
        log_warning "Please ensure domain resolves correctly before proceeding"
        read -p "Continue anyway? (y/N): " continue_anyway
        
        if [ "$continue_anyway" != "y" ] && [ "$continue_anyway" != "Y" ]; then
            log_info "Please configure DNS correctly and rerun this script"
            exit 1
        fi
    fi
    
    log_success "Domain configured: $DOMAIN"
    echo ""
}

# Install prerequisites
install_prerequisites() {
    log_info "Installing prerequisites..."
    
    # Update system
    if command -v apt &> /dev/null; then
        apt update
        apt install -y curl wget git
    elif command -v dnf &> /dev/null; then
        dnf update -y
        dnf install -y curl wget git
    fi
    
    # Install Docker if not present
    if ! command -v docker &> /dev/null; then
        log_info "Installing Docker..."
        curl -fsSL https://get.docker.com | sh
        systemctl enable docker
        systemctl start docker
    fi
    
    # Install Docker Compose if not present
    if ! command -v docker-compose &> /dev/null; then
        log_info "Installing Docker Compose..."
        curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    
    log_success "Prerequisites installed"
}

# Deploy using install script
deploy_application() {
    log_info "Deploying OpenVPN Controller..."
    
    # Download and run install script
    if command -v curl &> /dev/null; then
        curl -fsSL $INSTALL_SCRIPT_URL -o /tmp/install-openvpn-controller.sh
    else
        wget -q $INSTALL_SCRIPT_URL -O /tmp/install-openvpn-controller.sh
    fi
    
    chmod +x /tmp/install-openvpn-controller.sh
    
    # Run install script with domain
    /tmp/install-openvpn-controller.sh
    
    log_success "Application deployed"
}

# Post-deployment verification
verify_deployment() {
    log_info "Verifying deployment..."
    
    # Wait for services to start
    sleep 30
    
    # Check service status
    if systemctl is-active --quiet openvpn-controller; then
        log_success "OpenVPN Controller service is running"
    else
        log_error "OpenVPN Controller service is not running"
        journalctl -u openvpn-controller -f
        exit 1
    fi
    
    if systemctl is-active --quiet openvpn-server@server; then
        log_success "OpenVPN Server service is running"
    else
        log_error "OpenVPN Server service is not running"
        journalctl -u openvpn-server@server -f
        exit 1
    fi
    
    # Check API accessibility
    API_URL="http://localhost:8080/health"
    if curl -s $API_URL | grep -q "healthy"; then
        log_success "API health check passed"
    else
        log_error "API health check failed"
        exit 1
    fi
    
    log_success "Deployment verified"
}

# Display deployment information
display_info() {
    log_success "Deployment complete!"
    
    echo ""
    echo "📋 OpenVPN Controller Deployment Summary"
    echo "========================================"
    echo ""
    echo "🌐 Domain: $DOMAIN"
    echo "🔗 API URL: https://$DOMAIN/api/v1"
    echo "📡 OpenVPN Port: UDP 1194"
    echo ""
    echo "🔐 Default Credentials:"
    echo "   Username: admin"
    echo "   Password: secret123"
    echo ""
    echo "📁 Installation Directory:"
    echo "   /home/openvpn-admin/openvpn-controller"
    echo ""
    echo "🔧 Management Commands:"
    echo "   systemctl status openvpn-controller"
    echo "   systemctl restart openvpn-controller"
    echo "   journalctl -u openvpn-controller -f"
    echo ""
    echo "📊 Monitoring:"
    echo "   Grafana: http://$DOMAIN:3000 (admin/admin)"
    echo "   Prometheus: http://$DOMAIN:9090"
    echo ""
    echo "⚠️  Important Security Steps:"
    echo "   1. Change default password immediately"
    echo "   2. Configure fail2ban rules"
    echo "   3. Set up SSL certificates"
    echo "   4. Configure firewall rules"
    echo "   5. Enable 2FA if available"
    echo ""
    echo "📚 Documentation: https://github.com/$REPO_OWNER/$REPO_NAME"
    echo "🔧 Issues: https://github.com/$REPO_OWNER/$REPO_NAME/issues"
    echo ""
}

# Main deployment function
main() {
    echo "🚀 OpenVPN Controller One-Click Deployment"
    echo "=========================================="
    echo ""
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        log_error "Please run as root (use sudo)"
        exit 1
    fi
    
    # Display welcome message
    echo "This script will deploy OpenVPN Controller to your server."
    echo "It includes:"
    echo "  ✅ OpenVPN Server"
    echo "  ✅ REST API Controller"
    echo "  ✅ Web Management Interface"
    echo "  ✅ SSL Certificates"
    echo "  ✅ Monitoring (Prometheus + Grafana)"
    echo "  ✅ Fail2Ban Security"
    echo ""
    read -p "Continue with deployment? (y/N): " confirm
    
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log_info "Deployment cancelled"
        exit 0
    fi
    
    echo ""
    
    # Run deployment steps
    check_cloud_provider
    validate_requirements
    setup_domain
    install_prerequisites
    deploy_application
    verify_deployment
    display_info
    
    log_success "OpenVPN Controller has been successfully deployed!"
    log_info "Please follow the security steps listed above"
}

# Run main function
main