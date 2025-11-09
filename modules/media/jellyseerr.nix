{inputs, ...}: let
  inherit (inputs.self.niflheim) server;
in {
  flake.modules.nixos.media = {
    services.jellyseerr.enable = true;

    services.nginx.virtualHosts."jellyseerr.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:5055";
        proxyWebsockets = true;
      };
    };
  };
}
