# Media Stack Setup

The media stack consists of Jellyfin and the *arr suite for automated media management and streaming.

## Services Overview

### Core Media Services
- **Jellyfin**: Media server and streaming
- **Sonarr**: TV show automation
- **Radarr**: Movie automation
- **Bazarr**: Subtitle automation
- **Prowlarr**: Indexer management
- **SABnzbd**: Download client
- **Jellyseerr**: Request management

## Configuration

### Environment Variables
- `PUID/PGID`: User/group IDs for file permissions
- `TZ`: Timezone setting
- `CONFIG`: Path to service configurations
- `MOVIES`: Path to movies directory
- `TV`: Path to TV shows directory
- `TMPMEDIA`: Path to temporary download directory

### Ports
- **Jellyfin**: 8096
- **Sonarr**: 8989
- **Radarr**: 7878
- **Bazarr**: 6767
- **Prowlarr**: 9696
- **SABnzbd**: 8080
- **Jellyseerr**: 5055

## Initial Setup

1. Start all media services: `make up media`
2. Configure SABnzbd first (download client)
3. Configure Prowlarr (indexers)
4. Configure Sonarr and Radarr (automation)
5. Configure Bazarr (subtitles)
6. Configure Jellyfin (media server)
7. Configure Jellyseerr (requests)

## Service Dependencies

```
SABnzbd (Download) ← Prowlarr (Indexers)
       ↓                    ↓
    Sonarr/Radarr (Automation)
       ↓                    ↓
     Bazarr (Subtitles) → Jellyfin (Streaming)
```

## Indexer Configuration

Configure indexers in Prowlarr:
- Usenet indexers (NZBGeek, NZBPlanet, etc.)
- Torrent indexers (1337x, RARBG, etc.)

## Download Client Setup

SABnzbd configuration:
- Usenet servers (Giganews, Newshosting, etc.)
- Download categories
- Post-processing scripts

## Automation Workflow

1. User requests content via Jellyseerr
2. Sonarr/Radarr search for content via Prowlarr
3. SABnzbd downloads the content
4. Sonarr/Radarr move files to appropriate directories
5. Bazarr downloads subtitles
6. Jellyfin indexes and makes content available

## Troubleshooting

- Check download client connectivity
- Verify indexer API keys
- Review file permissions
- Check logs: `make logs media`

## Official Documentation

- [Sonarr](https://wiki.servarr.com/sonarr)
- [Radarr](https://wiki.servarr.com/radarr)
- [Bazarr](https://wiki.servarr.com/bazarr)
- [Prowlarr](https://wiki.servarr.com/prowlarr)
- [SABnzbd](https://sabnzbd.org/wiki/)
- [Jellyseerr](https://github.com/Fallenbagel/jellyseerr)
