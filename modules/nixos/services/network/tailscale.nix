{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.tailscale;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [tailscale];
    services.tailscale = {
      authKeyFile = config.age.secrets.tailscale.path;
      extraUpFlags = ["--ssh --accept-routes"];
    };
    system.persist.extraRootDirectories = ["/var/lib/tailscale"];
    networking.firewall = {
      trustedInterfaces = [config.services.tailscale.interfaceName];
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };
  };
}
