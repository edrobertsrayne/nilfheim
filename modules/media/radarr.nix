{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
  apikey = "45f0ce64ed8b4d34b51908c60b7a70fc";
  service = "radarr";
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
    };

    flake.nilfheim.server.proxy.services.${service} = {
      subdomain = "${service}.${server.domain}";
      port = cfg.settings.server.port;
    };

    users.users.${cfg.user}.extraGroups = ["tank"];
  };
}
