{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.common;
in {
  options.roles.common = {
    enable = mkEnableOption "Whether to enable to common role";
  };

  config = mkIf cfg.enable {
    modules = {
      hardware.network = enabled;
      services = {
        avahi = enabled;
        ssh = enabled;
        tailscale = enabled;
      };
      system = {
        boot = enabled;
        nix = enabled;
        persist = enabled;
      };
    };

    time.timeZone = "Europe/London";

    environment.systemPackages = with pkgs; [
      vim
      wget
      curl
      git
    ];
  };
}
