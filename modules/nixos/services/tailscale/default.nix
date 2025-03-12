{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.services.tailscale;
in {
  options.${namespace}.services.tailscale = with types; {
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
    networking.firewall = {
      trustedInterfaces = [config.services.tailscale.interfaceName];
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };
  };
}
