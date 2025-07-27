# HomeFleet

A comprehensive Docker-based homelab infrastructure showcasing modern container orchestration, service management, and platform engineering practices.

## Overview

HomeFleet is a production-ready homelab environment running 20+ Docker containers across media services, home automation, monitoring, and self-hosted applications. This repository demonstrates enterprise-level infrastructure management with a focus on maintainability, security, and scalability.

## Architecture

### Service Categories

- **Core Services**: Essential infrastructure (Home Assistant, Frigate, Z-Wave, Portainer)
- **Media Services**: Complete media server stack (Jellyfin, *arr services)
- **Utilities**: Support services (Heimdall, Duplicati, Watchtower)
- **Monitoring**: Observability and logging (Dozzle, Speedtest, SNMP)

### Key Features

- **Docker Compose**: All services managed via compose files
- **Makefile Orchestration**: Centralized service management
- **Remote SSH Deployment**: Designed for headless server operation
- **Hardware Acceleration**: AMD GPU support for media transcoding
- **Z-Wave Integration**: Home automation with USB controller
- **AI Object Detection**: Coral USB for Frigate NVR

## Quick Start

### Prerequisites

- Ubuntu 22.04+ with Docker and Docker Compose
- AMD GPU for hardware acceleration
- Z-Wave USB controller
- Coral USB for AI inference
- External storage mounted

### Setup

1. Clone this repository
2. Copy `.env.example` to `.env` and configure your environment
3. Run `make help` to see available commands
4. Start services with `make up <group>`

### Service Management

```bash
# Start all services
make up all

# Start specific service group
make up core
make up media
make up utilities
make up monitoring

# View service status
make status all

# View logs
make logs media

# Restart services
make restart core
```

## Service Documentation

Each service includes setup documentation in `setup_docs/`:

- [Home Assistant Setup](setup_docs/homeassistant_setup.md)
- [Jellyfin Setup](setup_docs/jellyfin_setup.md)
- [Frigate Setup](setup_docs/frigate_setup.md)
- [Media Stack Setup](setup_docs/media_stack_setup.md)

## Infrastructure

The `infra/` directory contains infrastructure configuration references and platform setup documentation.

## Contributing

This is a personal homelab project. For questions or suggestions, please open an issue.

## License

MIT License - see LICENSE file for details.
