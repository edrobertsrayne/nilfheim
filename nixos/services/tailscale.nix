{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.services.tailscale;
in {
  options.modules.services.tailscale = with types; {
    enable = mkEnableOption "Whether to enable tailscale service.";
    extraSetFlags = mkOption {
      type = listOf str;
      default = ["--ssh"];
      description = "Extra flags to pass to tailscale set";
    };
    extraUpFlags = mkOption {
      type = listOf str;
      default = ["--ssh"];
      description = "Extra flags to pass to tailscale up";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [tailscale];
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
      inherit (cfg) extraSetFlags extraUpFlags;
    };
    modules.system.persist.extraRootDirectories = ["/var/lib/tailscale"];
    networking.firewall = {
      trustedInterfaces = [config.services.tailscale.interfaceName];
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };
  };
}
