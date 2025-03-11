{
  pkgs,
  config,
  lib,
  options,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.suites.common;
in {
  options.${namespace}.suites.common = with types; {
    enable = mkEnableOption "Whether to enable common configuration.";
  };
  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/London";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
    # };

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb.layout = "gb";
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    services.libinput.enable = true;

    security.sudo.wheelNeedsPassword = false;

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      wget
      curl
      git
    ];

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
