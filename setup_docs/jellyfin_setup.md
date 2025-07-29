# Jellyfin Setup

Jellyfin is a free and open-source media server providing streaming, transcoding, and media management capabilities.

## Configuration

### Environment Variables
- `PUID/PGID`: User/group IDs for file permissions
- `TZ`: Timezone setting
- `CONFIG`: Path to Jellyfin configuration directory
- `MOVIES`: Path to movies directory
- `TV`: Path to TV shows directory

### Hardware Requirements
- AMD GPU for hardware acceleration (mapped as `/dev/dri/renderD128`)
- Sufficient storage for media files

### Ports
- **8096**: Web interface

### Volumes
- `${CONFIG}/jellyfin:/config`: Configuration and metadata
- `${TV}:/data/tvshows`: TV shows directory
- `${MOVIES}:/data/movies`: Movies directory

## Initial Setup

1. Start the container: `make up media`
2. Access web interface at `http://localhost:8096`
3. Complete the initial setup wizard
4. Add media libraries (Movies, TV Shows)
5. Configure hardware acceleration

## Hardware Acceleration

AMD GPU acceleration is configured for:
- H.264/H.265 transcoding
- Reduced CPU usage
- Better performance for multiple streams

## Media Organization

Recommended directory structure:
```
/movies/
  /Movie Name (Year)/
    Movie Name (Year).mkv
/tv/
  /Show Name/
    /Season 01/
      Show Name S01E01.mkv
```

## Integration with Media Stack

- **Sonarr**: Automatic TV show downloads
- **Radarr**: Automatic movie downloads
- **Bazarr**: Automatic subtitle downloads
- **Jellyseerr**: User request management

## Troubleshooting

- Verify GPU device mapping
- Check media file permissions
- Review transcoding settings
- Check logs: `make logs media`

## Official Documentation

- [Jellyfin Documentation](https://jellyfin.org/docs/)
- [Hardware Acceleration](https://jellyfin.org/docs/general/administration/hardware-acceleration/)
- [Docker Installation](https://jellyfin.org/docs/general/installation/container/)
