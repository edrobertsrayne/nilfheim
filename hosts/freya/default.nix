{
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  # Configure ZFS auto-snapshots for /home directory
  services.zfs.autoSnapshot = {
    enable = true;
    daily = 7; # Keep 7 daily snapshots (1 week)
    weekly = 4; # Keep 4 weekly snapshots (1 month)
    monthly = 3; # Keep 3 monthly snapshots (3 months)
  };

  # Configure NFS client to mount thor's shares
  services.nfs-client = {
    enable = true;
    server = "thor";
    mounts = {
      downloads = {
        remotePath = "/downloads";
        localPath = "/mnt/downloads";
      };
      media = {
        remotePath = "/media";
        localPath = "/mnt/media";
        options = ["soft" "intr" "bg" "vers=4" "ro"];
      };
      backup = {
        remotePath = "/backup";
        localPath = "/mnt/backup";
      };
      share = {
        remotePath = "/share";
        localPath = "/mnt/share";
      };
    };
  };
}
