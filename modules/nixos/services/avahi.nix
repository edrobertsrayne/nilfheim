{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.avahi;
in {
  config = mkIf cfg.enable {
    services.avahi = {
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
