{
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  # Enable desktop role (auto-enables common)
  roles.desktop.enable = true;

  # Configure backup service for freya
  services.backup.restic = {
    enable = true;
    paths = ["/persist" "/home"];
    repository = "/mnt/backup/freya/restic";
    schedule = "daily";
    retention = {
      keep-daily = 14;
      keep-weekly = 8;
      keep-monthly = 6;
      keep-yearly = 2;
    };
  };

  # Configure ZFS auto-snapshots for /home directory
  services.zfs.autoSnapshot = {
    enable = true;
    daily = 7; # Keep 7 daily snapshots (1 week)
    weekly = 4; # Keep 4 weekly snapshots (1 month)
    monthly = 3; # Keep 3 monthly snapshots (3 months)
  };
}
