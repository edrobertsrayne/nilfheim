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

    security.sudo.wheelNeedsPassword = false;

    environment.systemPackages = with pkgs; [
      vim
      wget
      curl
      git
    ];

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
