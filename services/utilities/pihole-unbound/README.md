# Pi-hole + Unbound DNS Stack

A complete DNS resolution stack with Pi-hole for ad-blocking and Unbound for recursive DNS resolution.

## Overview

This setup provides:
- **Pi-hole**: Ad-blocking DNS server with web interface
- **Unbound**: Recursive DNS resolver for privacy and performance
- **Internal DNS**: All DNS queries stay within the Docker network
- **No external DNS**: Complete privacy and control over DNS resolution

## Architecture

```
Internet → Unbound (5335) → Pi-hole (80) → Web UI (8080)
```

- **Unbound**: Handles recursive DNS resolution on port 5335
- **Pi-hole**: Blocks ads and serves as DNS server on port 80
- **Web UI**: Accessible on host port 8080

## Quick Start

1. **Set environment variable** (optional):
   ```bash
   export PIHOLE_PASSWORD=your_secure_password
   ```

2. **Start the services**:
   ```bash
   docker-compose up -d
   ```

3. **Access Pi-hole web interface**:
   - URL: http://localhost:8080/admin
   - Default password: `changeme` (or your PIHOLE_PASSWORD)

## Configuration

### Environment Variables

- `PIHOLE_PASSWORD`: Web interface password (default: `changeme`)
- `TZ`: Timezone (default: `America/New_York`)

### Volumes

- `./pihole/etc-pihole`: Pi-hole configuration
- `./pihole/etc-dnsmasq.d`: Custom dnsmasq configuration
- `./unbound/pi-hole.conf`: Unbound configuration
- `./unbound/root.hints`: DNS root hints

### Networks

- `dns_net`: Internal bridge network (172.20.0.0/16)
- No external port 53 exposure for security

## Usage

### Accessing Pi-hole

1. **Web Interface**: http://localhost:8080/admin
2. **CLI Access**: `docker exec -it pihole pihole status`

### Managing Blocklists

1. **Edit adlists**: Modify `pihole/etc-pihole/adlists.txt`
2. **Restore gravity**: `docker exec pihole /restore-gravity.sh`
3. **Manual update**: `docker exec pihole pihole -g`

### DNS Configuration

To use this DNS stack on your network:

1. **Router DNS**: Set primary DNS to your server IP
2. **Individual devices**: Configure DNS to your server IP
3. **Docker services**: Use `dns_net` network

## Health Checks

Both services include health checks:

- **Pi-hole**: Checks web interface accessibility
- **Unbound**: Verifies DNS resolution on port 5335

## Security Features

- ✅ **No external DNS exposure**: All queries internal
- ✅ **DNSSEC validation**: Enabled in Unbound
- ✅ **Privacy protection**: Hides identity and version
- ✅ **Private network isolation**: Custom bridge network
- ✅ **Health monitoring**: Automatic service monitoring

## Troubleshooting

### Common Issues

1. **Pi-hole not starting**:
   ```bash
   docker logs pihole
   ```

2. **Unbound not responding**:
   ```bash
   docker logs unbound
   ```

3. **DNS resolution issues**:
   ```bash
   docker exec pihole nslookup google.com 127.0.0.1
   ```

### Logs

- **Pi-hole logs**: `docker logs pihole`
- **Unbound logs**: `docker logs unbound`

### Manual Testing

```bash
# Test Pi-hole DNS
docker exec pihole nslookup google.com

# Test Unbound directly
docker exec unbound nslookup google.com 127.0.0.1 -port=5335

# Check gravity database
docker exec pihole sqlite3 /etc/pihole/gravity.db "SELECT COUNT(*) FROM gravity;"
```

## Integration with HomeFleet

This stack integrates with your HomeFleet homelab:

- **Network**: Uses custom `dns_net` bridge
- **Ports**: Web UI on 8080 (doesn't conflict with other services)
- **Volumes**: Persistent configuration storage
- **Health checks**: Monitored by Docker

## Performance

- **Memory usage**: ~50MB per container
- **CPU usage**: Minimal for typical home use
- **Storage**: ~100MB for configuration and databases
- **Network**: Internal DNS queries only

## Backup and Restore

### Backup Configuration

```bash
# Backup Pi-hole configuration
docker exec pihole tar czf - /etc/pihole > pihole-backup.tar.gz

# Backup Unbound configuration
docker exec unbound tar czf - /etc/unbound > unbound-backup.tar.gz
```

### Restore Configuration

```bash
# Restore Pi-hole configuration
docker exec -i pihole tar xzf - < pihole-backup.tar.gz

# Restore Unbound configuration
docker exec -i unbound tar xzf - < unbound-backup.tar.gz
```

## Customization

### Adding Custom Blocklists

1. Edit `pihole/etc-pihole/adlists.txt`
2. Add your custom list URLs
3. Run: `docker exec pihole /restore-gravity.sh`

### Custom DNS Records

Add to `pihole/etc-dnsmasq.d/01-custom.conf`:
```
# Custom local domain
address=/local/192.168.1.1

# Custom hostname
address=/myhost.local/192.168.1.100
```

### Unbound Customization

Edit `unbound/pi-hole.conf` for:
- Custom DNS servers
- Different cache settings
- Additional security options 