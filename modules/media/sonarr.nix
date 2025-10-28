{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
  apikey = "e6619670253d4b17baaa8a640a3aafed";
  service = "sonarr";
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

    services.cloudflared = {
      tunnels."${server.cloudflare.tunnel}" = {
        ingress = {
          "${service}.${server.domain}" = "http://127.0.0.1:${builtins.toString cfg.settings.server.port}";
        };
      };
    };

    users.users.${cfg.user}.extraGroups = ["tank"];
  };
}
