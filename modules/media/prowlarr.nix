{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
  apikey = "c20dce066e08419daaa4c2cbbe4ddcbe";
  service = "prowlarr";
in {
  flake.modules.nixos.media = {config, ...}: let
    cfg = config.services.${service};
  in {
    services = {
      ${service} = {
        enable = true;
        dataDir = "/srv/${service}";
        openFirewall = true;
        settings.auth = {
          method = "External";
          type = "DisabledForLocalAddresses";
          inherit apikey;
        };
      };
      flaresolverr.enable = true;
    };

    systemd.tmpfiles.rules = [
      "d ${config.services.prowlarr.dataDir} 0755 prowlarr prowlarr - -"
    ];

    services.cloudflared = {
      tunnels."${server.cloudflare.tunnel}" = {
        ingress = {
          "${service}.${server.domain}" = "http://127.0.0.1:${builtins.toString cfg.settings.server.port}";
        };
      };
    };
  };
}
