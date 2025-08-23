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
}
