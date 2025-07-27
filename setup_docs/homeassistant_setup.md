# Home Assistant Setup

Home Assistant is the central hub for home automation, integrating with Z-Wave devices, cameras, and other smart home components.

## Configuration

### Environment Variables
- `CONFIG`: Path to Home Assistant configuration directory
- `PUID/PGID`: User/group IDs for file permissions
- `TZ`: Timezone setting

### Hardware Requirements
- Z-Wave USB controller (mapped as `/dev/ttyUSB0`)
- Additional USB devices as needed

### Ports
- **8123**: Web interface

### Volumes
- `${CONFIG}/homeassistant:/config`: Configuration and data
- `/etc/localtime:/etc/localtime:ro`: System time
- `/run/dbus:/run/dbus:ro`: D-Bus system bus

### Devices
- `/dev/ttyUSB0:/dev/ttyUSB0`: Z-Wave controller
- `/dev/ttyUSB1:/dev/ttyUSB1`: Additional USB devices

## Initial Setup

1. Start the container: `make up core`
2. Access web interface at `http://localhost:8123`
3. Follow the initial setup wizard
4. Configure Z-Wave integration in the UI

## Integration with Other Services

- **Frigate**: Camera feeds and motion detection
- **Mosquitto**: MQTT communication
- **Z-Wave JS UI**: Z-Wave device management

## Troubleshooting

- Check device permissions for USB devices
- Verify Z-Wave controller is properly connected
- Review logs: `make logs core`

## Official Documentation

- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Z-Wave Integration](https://www.home-assistant.io/integrations/zwave_js/)
- [Docker Installation](https://www.home-assistant.io/installation/docker)
