{username, ...}: {
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

  # Configure services
  services = {
    # Configure ZFS auto-snapshots for /srv directory
    zfs.autoSnapshot = {
      enable = true;
      # Keep more snapshots to match previous retention policy
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
      shares = {
        downloads = {
          source = /mnt/downloads;
          permissions = "rw";
        };
        media = {
          source = /mnt/media;
          permissions = "ro";
        };
        backup = {
          source = /mnt/backup;
          permissions = "rw";
        };
        share = {
          source = /mnt/share;
          permissions = "rw";
        };
      };
    };

    samba = {
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
  };
}
