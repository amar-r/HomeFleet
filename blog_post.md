# HomeFleet: A Modern Docker-Based Homelab Infrastructure

## Introduction

HomeFleet represents a comprehensive approach to homelab infrastructure management, showcasing modern DevOps practices, container orchestration, and platform engineering principles. This project demonstrates how to build a production-ready homelab environment that balances functionality, maintainability, and scalability.

## Migration and Restructuring

### From Personal to Public

The migration from a private repository to a public, well-structured homelab project involved several key decisions:

1. **Service Selection**: Only actively running services were migrated, eliminating unused configurations and legacy setups
2. **Documentation Rewrite**: All documentation was rewritten from scratch, focusing on clarity and maintainability
3. **Security Sanitization**: Sensitive information was removed and replaced with placeholder configurations
4. **Structure Standardization**: Implemented a consistent directory structure following industry best practices

### Design Decisions

#### Container Orchestration
- **Docker Compose**: All services use Docker Compose for declarative configuration
- **Makefile Workflow**: Centralized service management through Makefile targets
- **Remote SSH Deployment**: Designed for headless server operation with remote management

#### Service Organization
- **Functional Grouping**: Services organized by function (core, media, utilities, monitoring)
- **Dependency Management**: Clear service dependencies and startup order
- **Configuration Management**: Centralized environment variables with service-specific overrides

## Architecture Overview

### Service Categories

#### Core Services
Essential infrastructure components that form the foundation of the homelab:
- **Home Assistant**: Central automation hub with Z-Wave integration
- **Frigate**: AI-powered NVR with object detection
- **Z-Wave JS UI**: Z-Wave device management
- **Portainer**: Docker container management

#### Media Services
Complete media server stack for content management and streaming:
- **Jellyfin**: Media server with hardware acceleration
- **Sonarr/Radarr**: Automated content management
- **Bazarr**: Subtitle automation
- **Prowlarr**: Indexer management
- **SABnzbd**: Download client
- **Jellyseerr**: Request management

#### Utilities
Support services that enhance the overall experience:
- **Heimdall**: Application dashboard
- **Duplicati**: Backup solution
- **Watchtower**: Automatic updates
- **Changedetection.io**: Website monitoring
- **Mosquitto**: MQTT broker
- **BookStack**: Documentation platform

#### Monitoring
Observability and performance tracking:
- **Dozzle**: Container log viewer
- **Speedtest Tracker**: Internet monitoring
- **SNMP Exporter**: Network device monitoring
- **Frigate Exporter**: Camera metrics

### Hardware Integration

#### AMD GPU Acceleration
- Hardware transcoding for Jellyfin
- Reduced CPU usage for multiple streams
- Optimized performance for media processing

#### Z-Wave Integration
- USB controller for home automation
- Integration with Home Assistant
- Device management through Z-Wave JS UI

#### AI Object Detection
- Google Coral USB for Frigate
- Real-time person and vehicle detection
- Motion event integration with Home Assistant

## Platform Engineering Principles

### Infrastructure as Code
- All configurations version controlled
- Declarative service definitions
- Reproducible deployments

### Observability
- Centralized logging with Dozzle
- Performance monitoring
- Health checks and status reporting

### Security
- Service isolation
- Authentication and authorization
- Regular security updates

### Scalability
- Horizontal scaling preparation
- Load balancing ready
- Multi-host deployment capable

## Technical Implementation

### Makefile Orchestration

The Makefile provides a unified interface for service management:

```makefile
# Service groups
CORE_SERVICES = homeassistant frigate zwave portainer
MEDIA_SERVICES = jellyfin sonarr radarr bazarr prowlarr sabnzbd jellyseerr
UTILITIES_SERVICES = heimdall duplicati watchtower changedetection mosquitto bookstack
MONITORING_SERVICES = monitoring logging dozzle speedtest frigate-exporter snmp-exporter

# Commands
make up core      # Start core services
make logs media   # View media service logs
make status all   # Check all service status
```

### Environment Management

Centralized environment configuration with service-specific overrides:

```bash
# Core environment variables
PUID=1000
PGID=1000
TZ=America/New_York
CONFIG=/path/to/configs
DATA=/path/to/data
```

### Service Dependencies

Clear dependency management ensures proper startup order:

1. Core infrastructure (Home Assistant, Frigate)
2. Media stack (Jellyfin, *arr services)
3. Utilities (Heimdall, Duplicati)
4. Monitoring (Dozzle, Speedtest)

## Future Roadmap

### Planned Enhancements
- **Traefik**: Reverse proxy and load balancer
- **Grafana**: Advanced monitoring dashboards
- **Prometheus**: Metrics collection and alerting
- **Authentik**: SSO and identity management

### Scalability Improvements
- Multi-host deployment
- Load balancing
- High availability setup

## Conclusion

HomeFleet demonstrates how modern DevOps practices can be applied to homelab environments. The project showcases:

- **Container Orchestration**: Efficient service management with Docker Compose
- **Platform Engineering**: Infrastructure as code with version control
- **Observability**: Comprehensive monitoring and logging
- **Security**: Proper access controls and regular updates
- **Scalability**: Future-ready architecture for growth

This infrastructure serves as both a functional homelab and a portfolio piece demonstrating platform engineering skills, container orchestration expertise, and infrastructure management capabilities.

## Repository Structure

```
HomeFleet/
├── services/
│   ├── core/           # Essential infrastructure
│   ├── media/          # Media server stack
│   ├── utilities/      # Support services
│   └── monitoring/     # Observability
├── infra/              # Infrastructure configuration
├── setup_docs/         # Service setup documentation
├── Makefile            # Service orchestration
├── .env.example        # Environment template
└── README.md           # Project documentation
```

The repository is designed to be immediately usable while providing a foundation for future enhancements and scaling.
