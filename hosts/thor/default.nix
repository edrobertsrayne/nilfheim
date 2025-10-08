{
  username,
  nilfheim,
  ...
}: let
  inherit (nilfheim) constants;

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
        builtins.mapAttrs (name: share: {
          source = share.path;
          permissions = share.nfsPermissions;
        })
        shareConfig;
    };

    samba = {
      enable = true;
      settings =
        builtins.mapAttrs (name: share: {
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
}
