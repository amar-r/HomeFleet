# Utilities Setup

Utility services provide essential support functions for the homelab infrastructure.

## Services Overview

### Core Utilities
- **Heimdall**: Application dashboard and launcher
- **Duplicati**: Backup solution
- **Watchtower**: Automatic container updates
- **Changedetection.io**: Website monitoring
- **Mosquitto**: MQTT broker
- **BookStack**: Documentation and wiki

## Configuration

### Environment Variables
- `PUID/PGID`: User/group IDs for file permissions
- `TZ`: Timezone setting
- `CONFIG`: Path to service configurations
- `DATA`: Path to data directory

### Ports
- **Heimdall**: 80, 443
- **Duplicati**: 8200
- **Watchtower**: 8190
- **Changedetection.io**: 5001
- **Mosquitto**: 1883
- **BookStack**: 6875

## Service Details

### Heimdall
Application dashboard providing quick access to all services.
- Configure application shortcuts
- Customize themes and layout
- Add service bookmarks

### Duplicati
Backup solution for configuration and data.
- Configure backup destinations
- Set up backup schedules
- Monitor backup status

### Watchtower
Automatic container updates.
- Configure update schedules
- Set update policies
- Monitor update logs

### Changedetection.io
Website monitoring and change detection.
- Add websites to monitor
- Configure notification settings
- Set up change filters

### Mosquitto
MQTT broker for IoT communication.
- Configure authentication
- Set up topics and permissions
- Monitor message traffic

### BookStack
Documentation and wiki platform.
- Create documentation structure
- Set up user accounts
- Configure backup settings

## Integration

- **Home Assistant**: Uses Mosquitto for MQTT communication
- **Frigate**: Can send events via MQTT
- **All Services**: Accessible via Heimdall dashboard

## Troubleshooting

- Check service connectivity
- Verify file permissions
- Review logs: `make logs utilities`

## Official Documentation

- [Heimdall](https://github.com/linuxserver/Heimdall)
- [Duplicati](https://www.duplicati.com/)
- [Watchtower](https://containrrr.dev/watchtower/)
- [Changedetection.io](https://github.com/dgtlmoon/changedetection.io)
- [Mosquitto](https://mosquitto.org/documentation/)
- [BookStack](https://www.bookstackapp.com/docs/)
