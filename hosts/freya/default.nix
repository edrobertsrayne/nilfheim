{
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  # Configure ZFS snapshots for /home directory
  services.zfs-snapshots = {
    enable = true;
    alerting.enable = true; # Enable Prometheus monitoring if available
    datasets = {
      "zroot/local/home" = {
        daily = 7; # Keep 7 daily snapshots (1 week)
        weekly = 4; # Keep 4 weekly snapshots (1 month)
        monthly = 3; # Keep 3 monthly snapshots (3 months)
        schedule = {
          daily = "01:00"; # 1 AM daily
          weekly = "Sun 02:00"; # 2 AM Sunday weekly
          monthly = "1 03:00"; # 3 AM first of month
        };
      };
    };
  };
}
