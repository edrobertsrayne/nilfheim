{username, ...}: let
  # Centralized share configuration to reduce duplication
  shareConfig = {
    downloads = {
      path = "/mnt/downloads";
      nfsPermissions = "rw";
      sambaReadOnly = false;
    };
    media = {
      path = "/mnt/media";
      nfsPermissions = "ro";
      sambaReadOnly = true;
    };
    backup = {
      path = "/mnt/backup";
      nfsPermissions = "rw";
      sambaReadOnly = false;
    };
    share = {
      path = "/mnt/share";
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
  };
}
