{
  # Port assignments for services (centralized to prevent conflicts)
  ports = {
    # *arr Services
    sonarr = 8989;
    radarr = 7878;
    lidarr = 8686;
    bazarr = 6767;
    prowlarr = 9696;

    # Media Services
    plex = 32400;
    jellyfin = 8096;
    jellyseerr = 5055;
    audiobookshelf = 8000;
    kavita = 5000;

    # Download Clients
    transmission = 9091;
    deluge = 8112;
    sabnzbd = 8080;
    autobrr = 7474;

    # Monitoring Services
    prometheus = 9090;
    grafana = 3000;
    alertmanager = 9093;
    uptime-kuma = 3001;
    loki = 3100;
    promtail = 9080;
    glances = 61208;

    # Prometheus Exporters
    exportarr-sonarr = 9709;
    exportarr-radarr = 9711;
    exportarr-lidarr = 9710;
    exportarr-bazarr = 9712;
    exportarr-prowlarr = 9713;
    node-exporter = 9100;

    # Utility Services
    homepage = 3002;
    n8n = 5678;
    code-server = 8443;
    stirling-pdf = 8081;
    karakeep = 8090;
    samba = 445;
    proxmox-ve = 8006;

    # Network Services
    blocky = 4000;
    ssh = 22;
    tailscale = 41641;
    avahi = 5353;
    nginx = 80;
    nginx-ssl = 443;

    # NFS Services
    nfs = 2049;
    rpcbind = 111;
    nfs-status = 20048;

    # Database Services
    postgresql = 5432;
    pgadmin = 5050;
  };

  # Default paths for services
  paths = {
    # Service data directories
    dataDir = "/srv";

    # Media storage paths
    media = "/mnt/media";
    movies = "/mnt/media/movies";
    tv = "/mnt/media/tv";
    music = "/mnt/media/music";
    audiobooks = "/mnt/media/audiobooks";
    comics = "/mnt/media/comics";

    # Download paths
    downloads = "/mnt/downloads";
    incomplete = "/mnt/downloads/incomplete";
    complete = "/mnt/downloads/complete";
    torrents = "/mnt/downloads/torrents";
    usenet = "/mnt/downloads/usenet";

    # Backup paths
    backup = "/mnt/backup";
    backups = "/mnt/backups";
    snapshots = "/mnt/snapshots";
    share = "/mnt/share";

    # Configuration paths
    configs = "/etc/nixos";
    secrets = "/run/agenix";
  };

  # API keys are now managed through agenix secrets
  # See secrets/sonarr-api.age, secrets/radarr-api.age, etc.

  # Service groups for homepage dashboard
  serviceGroups = {
    media = "Media";
    downloads = "Downloads";
    monitoring = "Monitoring";
    utilities = "Utilities";
    network = "Network";
  };

  # Common service descriptions
  descriptions = {
    # *arr Services
    sonarr = "TV series collection manager and downloader";
    radarr = "Movie collection manager and downloader";
    lidarr = "Music collection manager and downloader";
    bazarr = "Subtitle collection manager for Sonarr and Radarr";
    prowlarr = "Indexer manager for *arr applications";

    # Media Services
    plex = "Media server for streaming movies, TV, and music";
    jellyfin = "Open-source media server for movies, shows, and music";
    jellyseerr = "Request management system for Jellyfin";
    audiobookshelf = "Self-hosted audiobook and podcast server";
    kavita = "Cross-platform digital library for comics and ebooks";

    # Download Clients
    transmission = "Lightweight BitTorrent client";
    deluge = "Full-featured BitTorrent client";
    sabnzbd = "Binary newsreader for Usenet";
    autobrr = "Automated torrent management";

    # Monitoring Services
    prometheus = "Metrics collection and monitoring system";
    grafana = "Analytics and monitoring dashboards";
    alertmanager = "Alert routing and management for Prometheus";
    uptime-kuma = "Self-hosted uptime monitoring tool";
    loki = "Log aggregation system";
    promtail = "Log collection agent for Loki";
    glances = "System monitoring and process management";

    # Utility Services
    homepage = "Self-hosted application dashboard";
    n8n = "Workflow automation platform";
    code-server = "VS Code running in the browser";
    stirling-pdf = "PDF manipulation and processing tool";
    karakeep = "Karaoke song management system";
    proxmox-ve = "Virtualization management platform";

    # Network Services
    blocky = "DNS proxy and ad-blocker";
    samba = "File sharing service";
    nfs = "Network File System for remote file access";

    # Database Services
    postgresql = "PostgreSQL relational database server";
    pgadmin = "PostgreSQL administration web interface";
  };

  # Default authentication settings for *arr services
  arrAuthDefaults = {
    method = "External";
    type = "DisabledForLocalAddresses";
  };

  # Default nginx proxy settings
  nginxDefaults = {
    proxyWebsockets = true;
    extraConfig = ''
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_buffering off;
    '';
  };

  # ZFS snapshot retention policies
  snapshotRetention = {
    frequent = 4; # 15-minute snapshots
    hourly = 24;
    daily = 14; # Keep 14 daily snapshots (2 weeks) - Thor's current setting
    weekly = 8; # Keep 8 weekly snapshots (2 months) - Thor's current setting
    monthly = 6; # Keep 6 monthly snapshots (6 months) - Thor's current setting
  };

  # Common user groups
  userGroups = [
    "tank" # ZFS pool access
    "media" # Media files access
    "downloads" # Downloads access
  ];
}
