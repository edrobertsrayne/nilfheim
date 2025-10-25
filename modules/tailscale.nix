_: {
  flake.modules.nixos.tailscale = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = with pkgs; [tailscale];
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
      extraUpFlags = ["--ssh" "--accept-routes"];
    };
    networking.firewall = {
      trustedInterfaces = [config.services.tailscale.interfaceName];
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };
  };
}
