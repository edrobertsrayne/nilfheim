{
  username,
  nilfheim,
  config,
  ...
}: let
  inherit (nilfheim) constants;

  # Cloudflared tunnel configuration (local to thor)
  tunnel = "23c4423f-ec30-423b-ba18-ba18904ddb85";

  # Centralized share configuration to reduce duplication
  shareConfig = {
    downloads = {
      path = constants.paths.downloads;
      nfsPermissions = "rw";
      sambaReadOnly = false;
    };
    media = {
      path = constants.paths.media;
      nfsPermissions = "ro";
      sambaReadOnly = true;
    };
    backup = {
      path = constants.paths.backup;
      nfsPermissions = "rw";
      sambaReadOnly = false;
    };
    share = {
      path = constants.paths.share;
      nfsPermissions = "rw";
      sambaReadOnly = false;
    };
  };
in {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  # Enable server role (auto-enables common)
  roles.server.enable = true;

  # Ensure ZFS is set up properly
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["tank"];

  # Create tank group and add main user
  users.groups.tank.members = ["${username}"];

  # Configure tank mountpoints
  systemd.tmpfiles.rules = builtins.attrValues (builtins.mapAttrs (
      _name: share: "d ${share.path} 2775 root tank"
    )
    shareConfig);

  # Configure services
  services = {
    # Configure ZFS auto-snapshots for /srv directory
    zfs.autoSnapshot = {
      enable = true;
      frequent = 4; # 15-minute snapshots
      hourly = 24;
      daily = 14; # Keep 14 daily snapshots (2 weeks)
      weekly = 8; # Keep 8 weekly snapshots (2 months)
      monthly = 6; # Keep 6 monthly snapshots (6 months)
    };

    # Configure SMART monitoring with explicit devices
    smartctl-exporter = {
      devices = ["/dev/nvme0;nvme" "/dev/sda;sat"];
    };

    # Configure NFS server for tailscale network
    nfs-server = {
      enable = true;
      shares =
        builtins.mapAttrs (_name: share: {
          source = share.path;
          permissions = share.nfsPermissions;
        })
        shareConfig;
    };

    samba = {
      enable = true;
      settings =
        builtins.mapAttrs (_name: share: {
          "path" = share.path;
          "browseable" = "yes";
          "read only" =
            if share.sambaReadOnly
            then "yes"
            else "no";
          "guest ok" = "yes";
          "force user" = username;
          "force group" = "tank";
          "create mask" = "0644";
          "directory mask" = "0755";
        })
        shareConfig;
    };
  };

  nixpkgs.config.allowUnfree = true;

  virtualisation = {
    cleanuparr.enable = true;
    homeassistant.enable = true;
    huntarr.enable = true;
    tdarr.enable = true;
  };

  services = {
    audiobookshelf.enable = false;
    backup.restic = {
      enable = true;
      repository = "/mnt/backup/thor/restic";
    };
    bazarr.enable = true;
    blocky.enable = true;
    cadvisor.enable = true;
    code-server.enable = true;
    cloudflared = {
      enable = true;
      tunnels."${tunnel}" = {
        credentialsFile = config.age.secrets.cloudflare-homelab.path;
        default = "http_status:404";
        ingress = {
          "*.${config.domain.name}" = "http://localhost:80";
        };
      };
    };
    deluge.enable = false;
    flaresolverr.enable = true;
    glances.enable = true;
    grafana.enable = true;
    homepage-dashboard.enable = true;
    loki.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;
    karakeep.enable = true;
    kavita.enable = false;
    lidarr.enable = true;
    mealie.enable = true;
    n8n.enable = true;
    nginx.enable = true;
    pgadmin.enable = true;
    postgresql.enable = true;
    prometheus = {
      enable = true;
      alertmanager.enable = true;
    };
    promtail.enable = true;
    smartctl-exporter.enable = true;
    zfs-exporter.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    recyclarr.enable = true;
    sabnzbd.enable = true;
    sonarr.enable = true;
    stirling-pdf.enable = true;
    tailscale = {
      extraUpFlags = [
        "--exit-node 10.71.91.83"
        "--exit-node-allow-lan-access=true"
        ''--advertise-routes "192.168.68.0/24"''
      ];
    };
    transmission.enable = true;
    uptime-kuma.enable = true;
  };

  system.persist.extraRootDirectories = [
    {
      directory = "/var/lib/private";
      mode = "0700";
    }
  ];
}
