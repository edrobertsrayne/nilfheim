{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.avahi;
in {
  options.modules.services.avahi = {
    enable = mkEnableOption "Whether to enable avahi mDNS service.";
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
      };
    };
  };
}
