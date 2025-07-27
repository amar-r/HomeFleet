# Troubleshooting Guide

Common issues and solutions for HomeFleet services.

## General Issues

### Service Won't Start

1. **Check Docker Status**
   ```bash
   docker ps -a
   docker logs <container_name>
   ```

2. **Verify Environment Variables**
   ```bash
   source .env
   echo $CONFIG
   echo $PUID
   ```

3. **Check File Permissions**
   ```bash
   ls -la /path/to/config/directory
   sudo chown -R $PUID:$PGID /path/to/config/directory
   ```

### Port Conflicts

1. **Check Port Usage**
   ```bash
   sudo netstat -tulpn | grep :<port>
   sudo lsof -i :<port>
   ```

2. **Stop Conflicting Services**
   ```bash
   sudo systemctl stop <service_name>
   ```

## Service-Specific Issues

### Home Assistant

**Z-Wave Controller Not Found**
- Verify USB device is connected
- Check device permissions: `ls -la /dev/ttyUSB*`
- Add user to dialout group: `sudo usermod -a -G dialout $USER`

**Configuration Errors**
- Check configuration in `/config/configuration.yaml`
- Validate YAML syntax
- Review logs: `make logs core`

### Jellyfin

**Hardware Acceleration Not Working**
- Verify GPU device mapping
- Check AMD driver installation
- Review transcoding settings in Jellyfin UI

**Media Not Loading**
- Check file permissions
- Verify media directory mounts
- Review library configuration

### Media Stack

**Downloads Not Working**
- Check SABnzbd connectivity
- Verify indexer API keys in Prowlarr
- Review download client settings in Sonarr/Radarr

**Files Not Moving**
- Check file permissions
- Verify destination directory access
- Review post-processing settings

### Frigate

**Camera Stream Issues**
- Verify camera accessibility
- Check stream URL format
- Review camera configuration

**AI Detection Not Working**
- Verify Coral USB connection
- Check device permissions
- Review model configuration

## Network Issues

### DNS Resolution
- Check Pi-hole configuration
- Verify DNS server settings
- Test local domain resolution

### Port Access
- Check firewall rules
- Verify port forwarding
- Test service accessibility

## Performance Issues

### High CPU Usage
- Check hardware acceleration
- Review container resource limits
- Monitor service logs

### Storage Issues
- Check disk space: `df -h`
- Verify storage mounts
- Review backup configurations

## Log Analysis

### View Service Logs
```bash
# All services
make logs all

# Specific service group
make logs core
make logs media

# Individual service
docker logs <container_name>
```

### Common Log Patterns
- **Permission denied**: File permission issues
- **Connection refused**: Network connectivity problems
- **No space left**: Storage issues
- **Port already in use**: Port conflicts

## Recovery Procedures

### Service Recovery
1. Stop the service: `make down <group>`
2. Check configuration
3. Restart the service: `make up <group>`

### Full System Recovery
1. Stop all services: `make down all`
2. Check system resources
3. Restart services: `make up all`

### Backup Restoration
1. Stop affected services
2. Restore from Duplicati backup
3. Restart services

## Getting Help

1. Check service documentation in `setup_docs/`
2. Review official service documentation
3. Check GitHub issues for specific services
4. Review system logs for detailed error messages
