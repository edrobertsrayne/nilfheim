{username, ...}: let
  constants = import ../../lib/constants.nix;

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

  # Ensure ZFS is set up properly
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["tank"];

  # Create tank group and add main user
  users.groups.tank.members = ["${username}"];

  # Configure tank mountpoints
  systemd.tmpfiles.rules = builtins.attrValues (builtins.mapAttrs (
      name: share: "d ${share.path} 2775 root tank"
    )
    shareConfig);

  # Configure services
  services = {
    # Configure ZFS auto-snapshots for /srv directory
    zfs.autoSnapshot =
      constants.snapshotRetention
      // {
        enable = true;
      };

    # Configure SMART monitoring with explicit devices
    smartctl-exporter = {
      devices = ["/dev/nvme0;nvme" "/dev/sda;sat"];
    };

    # Configure NFS server for tailscale network
    nfs-server = {
      enable = true;
      shares =
        builtins.mapAttrs (name: share: {
          source = share.path;
          permissions = share.nfsPermissions;
        })
        shareConfig;
    };

    samba = {
      enable = true;
      settings = builtins.mapAttrs (name: share:
        {
          "path" = share.path;
          "browseable" = "yes";
          "read only" =
            if share.sambaReadOnly
            then "yes"
            else "no";
          "guest ok" = "no";
          "valid users" = username;
        }
        // (
          if share.sambaReadOnly
          then {}
          else {
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = username;
            "force group" = "users";
          }
        ))
      shareConfig;
    };

    # Music streaming services
    navidrome = {
      enable = true;
      settings = {
        MusicFolder = constants.paths.music;
        DataFolder = "${constants.paths.dataDir}/navidrome";
        Address = "127.0.0.1";
        Port = constants.ports.navidrome;
      };
    };

    beets = {
      enable = true;
    };

    your-spotify = {
      enable = true;
      # TODO: Add Spotify API credentials via secrets or environment
      clientId = "";
      clientSecret = "";
    };
  };
}
