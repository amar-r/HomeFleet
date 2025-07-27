# Infrastructure

Infrastructure configuration and platform setup for HomeFleet.

## Platform Overview

### Host System
- **OS**: Ubuntu 22.04 LTS
- **Architecture**: x86_64
- **Container Runtime**: Docker with Docker Compose
- **Orchestration**: Makefile-based workflow

### Hardware Configuration
- **CPU**: AMD processor with hardware acceleration
- **GPU**: AMD GPU for media transcoding
- **Storage**: External storage mounted at `/media/`
- **USB Devices**: Z-Wave controller, Coral USB accelerator

### Network Configuration
- **DNS**: Pi-hole integration (external)
- **Port Management**: Standard ports for each service
- **Security**: Firewall rules and access controls

## Directory Structure

```
infra/
├── README.md              # This file
├── dns/                   # DNS configuration references
├── storage/               # Storage configuration
└── network/               # Network configuration
```

## Storage Configuration

### Data Directories
- `/media/data/configs/`: Service configurations
- `/media/data/`: General data storage
- `/media/movies/`: Movie files
- `/media/tv/`: TV show files
- `/home/amar/tmpmedia/`: Temporary media processing

### Volume Management
- Docker volumes for persistent data
- External storage mounts for media
- Backup configuration for critical data

## Network Configuration

### Port Assignments
- **80, 443**: Heimdall (dashboard)
- **8123**: Home Assistant
- **5000**: Frigate
- **8096**: Jellyfin
- **8989**: Sonarr
- **7878**: Radarr
- **6767**: Bazarr
- **9696**: Prowlarr
- **8080**: SABnzbd
- **5055**: Jellyseerr
- **9000**: Portainer
- **9999**: Dozzle
- **8765**: Speedtest Tracker

### DNS Integration
- Pi-hole DNS server (external)
- Local domain resolution
- Service discovery

## Security Considerations

### Access Control
- Service-specific authentication
- Network isolation where appropriate
- Regular security updates via Watchtower

### Backup Strategy
- Duplicati for configuration backups
- Regular backup schedules
- Off-site backup storage

## Future Infrastructure

### Planned Additions
- **Traefik**: Reverse proxy and load balancer
- **Grafana**: Monitoring dashboards
- **Prometheus**: Metrics collection
- **Authentik**: SSO and identity management

### Scalability
- Horizontal scaling capabilities
- Load balancing preparation
- Multi-host deployment ready
