# OpenVPN 控制器 🚀

一个功能完整的 OpenVPN 管理系统，提供 REST API、Web 界面和自动化部署。

## 功能特性 ✨

- **RESTful API** - 完整的 OpenAPI 3.0.0 规范
- **JWT 认证** - 安全的基于令牌的身份验证
- **配置管理** - 动态 VPN 配置
- **访问控制** - 细粒度的 ACL 管理
- **服务监控** - 实时监控和指标
- **Web 界面** - 现代化的 Web 管理界面
- **Docker 支持** - 容器化部署
- **高可用性** - 生产级架构

## 快速开始 🚀

### 一键部署

```bash
# Ubuntu/Debian
wget https://raw.githubusercontent.com/your-username/openvpn-controller/main/scripts/install.sh
sudo bash install.sh

# CentOS/RHEL
curl -O https://raw.githubusercontent.com/your-username/openvpn-controller/main/scripts/install.sh
sudo bash install.sh
```

### Docker 部署

```bash
# 克隆仓库
git clone https://github.com/your-username/openvpn-controller.git
cd openvpn-controller

# 构建并运行
docker-compose up -d

# 访问 API
curl https://localhost/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"secret123"}'
```

## 文档 📚

- [API 文档](docs/api.md)
- [部署指南](docs/deployment.md)
- [用户手册](docs/user-manual.md)
- [架构设计](docs/architecture.md)
- [安全指南](docs/security.md)

## API 参考 🔧

### 身份验证

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "secret123"
}

响应:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

### 配置管理

```http
GET /api/v1/config
Authorization: Bearer YOUR_JWT_TOKEN

响应:
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

### 访问控制

```http
POST /api/v1/access-rules
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json

{
  "direction": "out",
  "action": "allow",
  "cidr": "0.0.0.0/0",
  "description": "允许所有出站流量"
}

响应:
{
  "id": "rule-001",
  "direction": "out",
  "action": "allow",
  "cidr": "0.0.0.0/0",
  "description": "允许所有出站流量"
}
```

## 系统架构 🏗️

```
┌─────────────────┐
│   Web 浏览器    │
└────────┬────────┘
         │
┌────────▼────────┐
│    Nginx        │
│  (反向代理)      │
└────────┬────────┘
         │
┌────────▼────────┐
│  OpenVPN        │
│  控制器 API     │
└────────┬────────┘
         │
┌────────▼────────┐
│  OpenVPN 服务器 │
└─────────────────┘
```

## 监控 📊

- **Prometheus 指标** - 系统和服务的监控指标
- **Grafana 仪表板** - 可视化监控
- **日志聚合** - 集中式日志管理
- **告警管理器** - 自动化告警

## 安全特性 🔒

- **JWT 认证** - 安全的基于令牌的身份验证
- **SSL/TLS** - 加密通信
- **Fail2Ban 集成** - 防止暴力破解
- **防火墙配置** - 网络安全
- **访问控制** - 细粒度权限管理
- **审计日志** - 安全审计记录

## 开发指南 💻

### 前置要求

- Python 3.8+
- Docker 和 Docker Compose
- OpenVPN
- Node.js (前端开发)

### 本地开发

```bash
# 克隆仓库
git clone https://github.com/your-username/openvpn-controller.git
cd openvpn-controller

# 创建虚拟环境
python3 -m venv venv
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 运行测试
python -m pytest tests/ -v

# 启动开发服务器
python src/main.py
```

### 代码规范

```bash
# 格式化代码
black src/ tests/

# 代码检查
flake8 src/ tests/

# 类型检查
mypy src/
```

## 部署指南 🚀

### 生产环境部署

```bash
# 使用部署脚本
./scripts/deploy.sh production

# 手动部署
./scripts/setup-openvpn.sh config/server.conf
sudo systemctl enable openvpn-controller
sudo systemctl start openvpn-controller
```

### 云部署

- **AWS** - CloudFormation 模板
- **Azure** - ARM 模板
- **GCP** - Deployment Manager
- **DigitalOcean** - 一键应用

## 贡献指南 🤝

1. Fork 本仓库
2. 创建功能分支
3. 进行代码修改
4. 添加测试用例
5. 提交 Pull Request

## 许可证 📄

MIT 许可证 - 详情见 [LICENSE](LICENSE) 文件

## 技术支持 💬

- [GitHub 问题](https://github.com/your-username/openvpn-controller/issues)
- [讨论区](https://github.com/your-username/openvpn-controller/discussions)
- [Wiki](https://github.com/your-username/openvpn-controller/wiki)

## 更新日志 📝

详见 [CHANGELOG.md](CHANGELOG.md) 获取版本更新信息。

---

**由 OpenVPN 控制器团队用 ❤️ 制作**