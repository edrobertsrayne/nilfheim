# Music Streaming Services

Comprehensive self-hosted music streaming ecosystem with organization, analytics, and streaming capabilities.

## 🎵 Service Overview

### Architecture

```
Music Workflow:
Lidarr → Downloads → Beets → Organizes → Navidrome → Streams
                       ↓
              Your Spotify ← Analytics
```

### Core Components

| Service | Purpose | Port | URL | Status |
|---------|---------|------|-----|--------|
| **Navidrome** | Music streaming server | 4533 | `https://navidrome.greensroad.uk` | ✅ Active |
| **Beets** | Library organization | 8337 | `https://beets.greensroad.uk` | ✅ Active |
| **Your Spotify** | Analytics dashboard | 4537 | `https://spotify.greensroad.uk` | ✅ Active |

## 🎧 Navidrome - Music Streaming

### Overview
Modern music streaming server compatible with Subsonic/Airsonic clients, providing web-based streaming and mobile app support.

### Key Features
- **Web Interface**: Modern, responsive music player
- **Mobile Apps**: Native iOS/Android client support via Subsonic API
- **Multi-User**: User accounts with personal playlists and preferences
- **Scrobbling**: Last.fm integration for listening statistics
- **Format Support**: MP3, FLAC, OGG, M4A, and more
- **Smart Playlists**: Dynamic playlist generation

### Configuration
```nix
services.navidrome = {
  enable = true;
  settings = {
    MusicFolder = "/mnt/media/music";
    DataFolder = "/srv/navidrome";
    Address = "127.0.0.1";
    Port = 4533;
  };
};
```

### Integration
- **Music Library**: Reads from `/mnt/media/music` (same as Beets output)
- **User Management**: Integrated user system with admin controls
- **Database**: Built-in SQLite database for metadata and user data
- **API**: Full Subsonic API compatibility for third-party clients

### Administration
- **Initial Setup**: Create admin user on first access
- **User Management**: Admin interface for user accounts
- **Library Scanning**: Automatic scanning with configurable intervals
- **Backup**: Database located at `/srv/navidrome/`

## 🏷️ Beets - Music Library Organization

### Overview
Advanced music library organizer that automatically tags, renames, and organizes music files with comprehensive metadata enhancement.

### Key Features
- **Auto-Tagging**: MusicBrainz integration for accurate metadata
- **Duplicate Detection**: Intelligent duplicate identification
- **Format Conversion**: Audio format transcoding capabilities
- **Plugin Ecosystem**: Extensible functionality with 60+ plugins
- **Web Interface**: Browser-based library management
- **CLI Tools**: Powerful command-line interface

### Configuration
```nix
services.beets = {
  enable = true;
  webInterface = true;
  musicLibrary = "/mnt/media/music";
  musicSource = "/mnt/media/downloads/music";
};
```

### Enabled Plugins
- **fetchart**: Album artwork downloading
- **embedart**: Embed artwork in files
- **scrub**: Remove unnecessary metadata
- **replaygain**: Volume normalization
- **chroma**: Acoustic fingerprinting
- **lastgenre**: Genre tagging
- **duplicates**: Duplicate detection

### Workflow Integration
1. **Input**: Music files from Lidarr downloads (`/mnt/media/downloads/music`)
2. **Processing**: Auto-tagging, artwork fetching, organization
3. **Output**: Clean, organized library (`/mnt/media/music`)
4. **Consumption**: Served by Navidrome

### Usage Examples
```bash
# Import new music
beet import /mnt/media/downloads/music

# Update all metadata
beet update

# Find duplicates
beet duplicates

# Web interface access
https://beets.greensroad.uk
```

## 📊 Your Spotify - Analytics Dashboard

### Overview
Self-hosted Spotify listening analytics providing detailed insights into listening habits, favorite tracks, and music discovery patterns.

### Key Features
- **Listening History**: Complete playback history tracking
- **Statistics Dashboard**: Charts, graphs, and listening insights
- **Top Charts**: Most played tracks, artists, and albums
- **Privacy Focused**: Self-hosted alternative to Spotify's analytics
- **Data Export**: Export listening data for analysis
- **Multi-User**: Support for multiple Spotify accounts

### Configuration
```nix
services.your-spotify = {
  enable = true;
  clientId = "your_spotify_client_id";
  clientSecret = "your_spotify_client_secret";
};
```

### Database Integration
- **PostgreSQL**: Uses shared PostgreSQL instance
- **Database**: `yourspotify` database with dedicated user
- **Schema**: Automatic initialization on service start
- **Data Retention**: Configurable history retention periods

### Setup Requirements
1. **Spotify App**: Create app in Spotify Developer Dashboard
2. **API Credentials**: Configure `clientId` and `clientSecret`
3. **Callback URL**: Set to `https://spotify.greensroad.uk/api/auth/callback`
4. **Account Linking**: Connect Spotify accounts via web interface

### Analytics Features
- **Playback History**: Track every song played
- **Time Analytics**: Listening patterns by hour/day/month
- **Genre Analysis**: Music taste evolution over time
- **Discovery Metrics**: New vs. repeated content analysis
- **Social Features**: Compare listening habits (if enabled)

## 🔧 Service Architecture

### Data Flow
```
1. Lidarr detects new releases
2. Downloads music to /mnt/media/downloads/music
3. Beets imports and organizes to /mnt/media/music
4. Navidrome serves organized library
5. Your Spotify tracks streaming analytics
```

### Integration Points

#### Database Services
- **Navidrome**: Self-contained SQLite database
- **Your Spotify**: PostgreSQL integration with shared instance
- **Beets**: File-based configuration with SQLite library database

#### Storage Layout
```
/mnt/media/
├── downloads/music/    # Lidarr download staging
├── music/              # Organized library (Beets → Navidrome)
└── ...

/srv/
├── navidrome/          # Navidrome data and database
├── beets/              # Beets configuration and library DB
├── your-spotify/       # Your Spotify application data
└── postgresql/         # Shared PostgreSQL instance
```

#### Network Configuration
- **Reverse Proxy**: All services behind Nginx with SSL termination
- **WebSocket Support**: Real-time updates for web interfaces
- **Authentication**: Per-service authentication systems
- **Security**: Tailscale network isolation with external HTTPS access

## 🎯 Usage Workflows

### Daily Music Discovery
1. **Lidarr**: Automatically downloads new releases
2. **Beets**: Organizes and tags new music (manual or automated)
3. **Navidrome**: Browse and play organized music
4. **Your Spotify**: Track listening habits and discovery

### Library Maintenance
1. **Beets Web Interface**: Review and correct metadata
2. **Duplicate Management**: Use Beets duplicate detection
3. **Quality Control**: Manual review of auto-tagged content
4. **Backup**: Regular backup of `/srv/` directories

### Analytics and Insights
1. **Your Spotify**: Review listening statistics
2. **Navidrome**: Monitor user activity and popular content
3. **Database Queries**: Custom analytics via pgAdmin

## 🔒 Security Configuration

### Authentication
- **Navidrome**: Built-in user management system
- **Beets**: No authentication (internal network only)
- **Your Spotify**: Spotify OAuth integration

### Network Access
- **External**: HTTPS access via Cloudflare tunnels
- **Internal**: Direct access via Tailscale network
- **Firewall**: Service ports closed to public internet

### Data Protection
- **Encryption**: HTTPS for all external communication
- **Secrets**: API credentials managed via agenix
- **Backup**: Regular snapshots via ZFS auto-snapshots

## 🚀 Future Enhancements

### Planned Additions ([Issue #49](https://github.com/edrobertsrayne/nilfheim/issues/49))
- **Mopidy**: Unified interface for Spotify + local music
- **Maloja**: Self-hosted scrobbling server
- **SpotDL**: Spotify playlist backup tool

### Integration Opportunities
- **Last.fm Scrobbling**: Universal scrobbling across all services
- **Mobile Apps**: Enhanced mobile experience via Subsonic clients
- **Smart Playlists**: Cross-service playlist synchronization
- **Advanced Analytics**: Custom dashboards with Grafana integration

## 📚 References

### Documentation
- **[Navidrome Documentation](https://www.navidrome.org/docs/)**
- **[Beets Documentation](https://beets.readthedocs.io/)**
- **[Your Spotify Setup](https://github.com/Yooooomi/your_spotify)**

### Client Applications
- **Mobile**: DSub, Ultrasonic, play:Sub (Subsonic clients)
- **Desktop**: Sublime Music, Sonixd, Supersonic
- **Web**: Built-in interfaces for all services

### Integration Examples
- **Service Configuration**: `modules/nixos/services/media/` and `modules/nixos/services/utilities/`
- **Host Configuration**: `hosts/thor/default.nix`
- **Constants**: `lib/constants.nix` for ports and paths

---

*This documentation covers the complete music streaming ecosystem deployed as part of the Nilfheim homelab infrastructure.*