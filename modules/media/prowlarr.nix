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

    flake.nilfheim.server.proxy.services.${service} = {
      subdomain = "${service}.${server.domain}";
      port = cfg.settings.server.port;
    };
  };
}
