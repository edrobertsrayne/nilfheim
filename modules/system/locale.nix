_: {
  flake.modules.nixos.nixos = {
    # UK timezone - automatically handles GMT/BST transitions
    time.timeZone = "Europe/London";

    # UK English locale settings
    i18n = {
      defaultLocale = "en_GB.UTF-8";

      # Specific locale settings with fallback to en_US.UTF-8 for compatibility
      extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };
    };

    # UK keyboard layout for console (TTY)
    console.keyMap = "uk";
  };
}
