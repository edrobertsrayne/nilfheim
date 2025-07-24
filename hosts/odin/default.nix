{
  username,
  lib,
  ...
}: {
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
      # Add any macOS-specific command-line tools here
    ];
  };
}
