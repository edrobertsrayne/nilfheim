let
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
    cleanuparr = 11011;
    huntarr = 9705;

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
    mealie = 9000;
    samba = 445;
    homeassistant = 8123;

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

    # Container Management
    portainer = 9443;
    portainer-http = 9002;
    portainer-agent = 9001;
    cadvisor = 9800;
  };

  # Default paths for services
  # Only commonly used paths that appear in multiple service configurations
  paths = {
    # Service data directories
    dataDir = "/srv";

    # Media storage paths
    media = "/mnt/media";
    movies = "/mnt/media/movies";
    tv = "/mnt/media/tv";
    music = "/mnt/media/music";

    # Download and backup paths
    downloads = "/mnt/downloads";
    backup = "/mnt/backup";
    share = "/mnt/share";
  };

  # Port conflict validation - check for duplicate port assignments
  portValues = builtins.attrValues ports;
  sortedPorts = builtins.sort (a: b: a < b) portValues;

  # Simple duplicate detection: if sorted list has adjacent duplicates, we have conflicts
  hasDuplicates = builtins.any (
    i:
      i
      < (builtins.length sortedPorts - 1)
      && builtins.elemAt sortedPorts i == builtins.elemAt sortedPorts (i + 1)
  ) (builtins.genList (i: i) (builtins.length sortedPorts));
in
  # Validate no port conflicts exist
  assert !hasDuplicates
  || throw "Port conflict detected in constants.ports. Check for duplicate port assignments."; {
    inherit
      ports
      paths
      ;
  }
