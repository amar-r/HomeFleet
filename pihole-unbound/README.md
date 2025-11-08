# Pi-hole + Unbound DNS Stack

A complete DNS resolution stack with Pi-hole for ad-blocking and Unbound for recursive DNS resolution, configured for pfSense integration.

## Overview

This setup provides:
- **Pi-hole**: Ad-blocking DNS server with web interface
- **Unbound**: Recursive DNS resolver for privacy and performance
- **pfSense Integration**: Configured to work with pfSense firewall
- **Standard DNS Port**: Runs on port 53 for seamless integration

## Quick Start

1. **Set environment variables** (create `.env` file):
   ```bash
   cp env.example .env
   # Edit .env with your values
   ```

2. **Start the services**:
   ```bash
   cd /path/to/HomeFleet
   make up utilities
   ```

3. **Access Pi-hole web interface**:
   - URL: http://localhost:8081/admin
   - Default password: `changeme` (or your PIHOLE_PASSWORD)

## pfSense Integration

### Prerequisites
- Disable `systemd-resolved` on Ubuntu:
  ```bash
  sudo systemctl stop systemd-resolved
  sudo systemctl disable systemd-resolved
  ```

### pfSense Configuration

1. **DNS Settings**:
   - Go to **System** → **General Setup**
   - Set **DNS Server 1** to your Pi-hole server IP
   - Uncheck "Allow DNS server list to be overridden by DHCP/PPP on WAN"

2. **DHCP Server**:
   - Go to **Services** → **DHCP Server** → **[LAN]**
   - Set **DNS Servers** to your Pi-hole IP only

3. **Firewall Rules**:
   - Create rule to allow UDP/TCP port 53 to Pi-hole IP
   - Source: LAN net, Destination: Pi-hole IP, Port: 53

## Configuration

### Environment Variables

- `PIHOLE_WEBPASSWORD`: Web interface password
- `TZ`: Timezone (default: `America/New_York`)

### Adlists Management

The `adlists.txt` file contains curated ad-blocking lists. To add more lists:

1. **Via Web Interface** (Recommended):
   - Go to **Group Management** → **Adlists**
   - Add URLs manually

2. **Via File** (Advanced):
   - Edit `adlists.txt` with additional URLs
   - Restart the container

## Security Considerations

⚠️ **Important**: This repository is public. Never commit:
- `.env` files with passwords
- Pi-hole database files (`*.db`)
- Certificate files (`*.crt`, `*.pem`)
- Log files with sensitive data

## Troubleshooting

### Port 53 Already in Use
```bash
# Check what's using port 53
sudo ss -tulpn | grep :53

# Stop systemd-resolved if needed
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
```

### DNS Not Working
```bash
# Check Pi-hole status
docker exec pihole pihole status

# Check DNS resolution
nslookup google.com localhost
```

### pfSense Can't Reach Pi-hole
1. Verify Pi-hole is running: `docker compose ps`
2. Check firewall rules in pfSense
3. Test connectivity: `ping <pi-hole-ip>`

## Health Checks

Both services include health checks:
- **Pi-hole**: Checks web interface accessibility
- **Unbound**: Verifies DNS resolution on port 53

## Network Architecture

```
Internet → pfSense → Pi-hole (53) → Unbound → Clients
```

- **Pi-hole**: Handles ad-blocking and DNS serving on port 53
- **Unbound**: Provides recursive DNS resolution
- **pfSense**: Routes all DNS traffic to Pi-hole

## Maintenance

### Update Adlists
```bash
# Via web interface (recommended)
# Or manually:
docker exec pihole pihole -g
```

### Backup Configuration
```bash
# Backup Pi-hole config
docker exec pihole pihole -a -p
```

### Logs
```bash
# View Pi-hole logs
docker exec pihole pihole -t

# View container logs
docker compose logs pihole
``` 