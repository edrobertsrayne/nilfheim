{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
  apikey = "f6a4315040e94c7c9eb2aefe5bfc4445";
  service = "lidarr";
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
