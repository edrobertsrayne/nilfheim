{
  username,
  lib,
  ...
}: {
  # Configure ZFS snapshots for home directory
  services.zfs-snapshots = {
    enable = true;
    datasets = {
      # Assuming ZFS pool setup for home directory on macOS
      # This will need to be adjusted based on actual ZFS setup on odin
      "zroot/home" = {
        daily = 7; # Keep 7 daily snapshots
        weekly = 4; # Keep 4 weekly snapshots
        monthly = 3; # Keep 3 monthly snapshots
        schedule = {
          daily = "02:00"; # 2 AM daily
          weekly = "Sun 03:00"; # 3 AM Sunday weekly
          monthly = "1 04:00"; # 4 AM first of month
        };
      };
    };
  };

  # macOS specific configuration
  system.defaults = {
    dock.autohide = true;
    finder.FXPreferredViewStyle = "clmv";
  };

  # Enable Homebrew for packages not available in Nix
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    # Homebrew casks for GUI applications
    casks = [
      # Add any macOS-specific applications here
    ];

    # Homebrew formulas for command-line tools
    brews = [
      # OpenZFS for macOS - required for ZFS snapshots
      "openzfs"
    ];
  };
}
