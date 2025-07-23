{
  username,
  lib,
  ...
}: {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  # Ensure ZFS is set up properly
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["tank"];

  # Create tank group and add main user
  users.groups.tank.members = ["${username}"];

  # Configure tank mountpoints
  systemd.tmpfiles.rules = [
    "d /mnt/downloads 2775 root tank"
    "d /mnt/media 2775 root tank"
    "d /mnt/backup 2775 root tank"
    "d /mnt/share 2775 root tank"
  ];

  # Configure ZFS snapshots for /srv directory
  services.zfs-snapshots = {
    enable = true;
    alerting.enable = true; # Enable Prometheus monitoring
    datasets = {
      "zroot/local/srv" = {
        daily = 14; # Keep 14 daily snapshots (2 weeks)
        weekly = 8; # Keep 8 weekly snapshots (2 months)
        monthly = 6; # Keep 6 monthly snapshots (6 months)
        schedule = {
          daily = "01:30"; # 1:30 AM daily (before other backups)
          weekly = "Sun 02:30"; # 2:30 AM Sunday weekly
          monthly = "1 03:30"; # 3:30 AM first of month
        };
      };
    };
  };

  services.samba = {
    enable = true;
    settings = {
      "backup" = {
        "path" = "/mnt/backup";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = username;
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = username;
        "force group" = "users";
      };
      "downloads" = {
        "path" = "/mnt/downloads";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = username;
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = username;
        "force group" = "users";
      };
      "media" = {
        "path" = "/mnt/media";
        "browseable" = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "valid users" = username;
      };
      "share" = {
        "path" = "/mnt/share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = username;
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = username;
        "force group" = "users";
      };
    };
  };
}
