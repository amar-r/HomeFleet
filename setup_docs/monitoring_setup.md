# Monitoring Setup

Monitoring services provide observability, logging, and performance tracking for the homelab infrastructure.

## Services Overview

### Monitoring Stack
- **Dozzle**: Container log viewer
- **Speedtest Tracker**: Internet speed monitoring

## Configuration

### Environment Variables
- `PUID/PGID`: User/group IDs for file permissions
- `TZ`: Timezone setting
- `CONFIG`: Path to service configurations

### Ports
- **Dozzle**: 9999
- **Speedtest Tracker**: 8765
- **SNMP Exporter**: 9116
- **Frigate Exporter**: 9325

## Service Details

### Dozzle
Real-time container log viewer.
- View logs from all containers
- Filter by container name
- Search log content
- Monitor resource usage

### Speedtest Tracker
Internet speed monitoring and tracking.
- Configure speed test schedules
- Track upload/download speeds
- Generate performance reports
- Set up notifications

## Integration

- **Prometheus**: Metrics collection (future)
- **Grafana**: Visualization (future)
- **Home Assistant**: Speed test data
- **All Services**: Log viewing via Dozzle

## Future Monitoring Stack

Planned additions:
- **Prometheus**: Metrics collection
- **Grafana**: Dashboards and visualization
- **Alertmanager**: Alert management
- **Node Exporter**: Host metrics

## Troubleshooting

- Check service connectivity
- Verify SNMP configuration
- Review logs: `make logs monitoring`

## Official Documentation

- [Dozzle](https://github.com/amir20/dozzle)
- [Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker)
