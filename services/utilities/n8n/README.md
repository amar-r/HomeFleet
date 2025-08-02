# n8n - Local-First Automation

This folder contains the local deployment of n8n using Docker Compose. n8n is exposed only to `localhost` and secured with basic auth for maximum privacy and security.

## 🏃‍♂️ Quick Start

1. **Start n8n:**
   ```bash
   # From HomeFleet root directory
   make up utilities
   
   # Or directly from this directory
   docker compose up -d
   ```

2. **Access n8n:**
   - URL: [http://localhost:5678](http://localhost:5678)
   - Username: `admin`
   - Password: `changeme`

## 🔐 Security Features

- **Local-only access**: Bound to `127.0.0.1:5678` (no external network access)
- **Basic authentication**: Required login with username/password
- **Persistent storage**: All workflows and data stored in Docker volume `n8n_data`
- **No external dependencies**: Self-contained with SQLite database
- **Environment variables**: Loaded from root `.env` file for Makefile integration

## 💾 Data Persistence

- **Workflows**: Stored in Docker volume `n8n_data`
- **Credentials**: Stored in Docker volume `n8n_data`
- **Database**: SQLite file in Docker volume `n8n_data`
- **Local files**: Available in `./local-files` directory
- **Logs**: Available via `docker compose logs n8n`

## 🌍 Optional: External Access via Cloudflare Tunnel

To securely expose n8n externally while maintaining security:

### 1. Install Cloudflare Tunnel
```bash
# Download cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
```

### 2. Authenticate with Cloudflare
```bash
cloudflared login
```

### 3. Create Tunnel
```bash
cloudflared tunnel create n8n-tunnel
```

### 4. Configure Tunnel
Create `~/.cloudflared/config.yml`:
```yaml
tunnel: n8n-tunnel
credentials-file: /home/YOURUSER/.cloudflared/n8n-tunnel.json

ingress:
  - hostname: n8n.yourdomain.com
    service: http://localhost:5678
  - service: http_status:404
```

### 5. Add DNS Record
In your Cloudflare DNS settings, add a CNAME:
- Name: `n8n`
- Target: `n8n-tunnel.yourdomain.com.trycloudflare.com`

### 6. Run Tunnel
```bash
cloudflared tunnel run n8n-tunnel
```

## 🔒 Optional: Cloudflare Access Login Wall

Use Cloudflare Access to restrict who can access your tunnel:

1. **Enable Access** in your Cloudflare dashboard
2. **Create an Access Policy**:
   - Application: `n8n.yourdomain.com`
   - Action: `Allow`
   - Rules: Choose your authentication method (email, GitHub, SSO, etc.)
3. **Add users/teams** to the policy

## 🛠️ Management Commands

```bash
# Start n8n
make up utilities

# Stop n8n
make down utilities

# View logs
make logs utilities

# Restart n8n
make restart utilities

# Check status
make status utilities
```

## 📊 Monitoring

- **Container logs**: `docker compose logs -f n8n`
- **Resource usage**: `docker stats n8n`
- **Database size**: Check `./data/database/` directory

## 🔧 Troubleshooting

### Port Already in Use
If port 5678 is already in use:
```bash
# Check what's using the port
sudo netstat -tlnp | grep 5678

# Change port in .env
N8N_PORT=5679
```

### Authentication Issues
- Ensure `.env` file exists and has correct credentials
- Check container logs: `docker compose logs n8n`

### Data Loss
- All data is persisted in `./data/` volume
- Backup the `./data/` directory regularly
- Consider using external database for production

## 🚀 Advanced Configuration

### Using External Database
Uncomment and configure PostgreSQL in `.env`:
```bash
N8N_DATABASE_TYPE=postgresdb
N8N_DATABASE_POSTGRESDB_HOST=your-postgres-host
N8N_DATABASE_POSTGRESDB_DATABASE=n8n
N8N_DATABASE_POSTGRESDB_USER=n8n
N8N_DATABASE_POSTGRESDB_PASSWORD=your_password
```

### Using Redis for Queue Management
Uncomment and configure Redis in `.env`:
```bash
N8N_REDIS_HOST=your-redis-host
N8N_REDIS_PORT=6379
N8N_REDIS_PASSWORD=your_redis_password
```

---

This setup is self-contained and safe for private automation without exposing any external ports. Perfect for local-first automation workflows! 