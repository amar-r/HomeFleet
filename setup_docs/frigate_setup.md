# Frigate Setup

Frigate is a Network Video Recorder (NVR) with AI object detection, providing motion detection and recording for security cameras.

## Configuration

### Environment Variables
- `CONFIG`: Path to Frigate configuration directory
- `PUID/PGID`: User/group IDs for file permissions
- `TZ`: Timezone setting

### Hardware Requirements
- Coral USB accelerator for AI inference
- GPU for hardware acceleration (optional)

### Ports
- **5000**: Web interface

### Volumes
- `${CONFIG}/frigate:/config`: Configuration and data
- Camera streams and recordings

## Initial Setup

1. Start the container: `make up core`
2. Access web interface at `http://localhost:5000`
3. Configure cameras in the web interface
4. Set up motion detection zones

## AI Object Detection

Frigate uses Google Coral USB for real-time object detection:
- Person detection
- Vehicle detection
- Custom object detection

## Integration with Home Assistant

- Camera feeds available in Home Assistant
- Motion events trigger automations
- Recording clips accessible via Home Assistant

## Troubleshooting

- Verify Coral USB is properly connected
- Check camera stream accessibility
- Review logs: `make logs core`

## Official Documentation

- [Frigate Documentation](https://docs.frigate.video/)
- [Hardware Acceleration](https://docs.frigate.video/installation/hardware)
- [Configuration](https://docs.frigate.video/configuration/)
