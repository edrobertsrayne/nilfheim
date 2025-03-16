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
      services = {
        avahi = enabled;
        ssh = enabled;
      };
      system = {
        boot = enabled;
        nix = enabled;
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
