{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
in {
  flake.modules.nixos.media = {
    services.jellyseerr.enable = true;

    services.cloudflared = {
      tunnels."${server.cloudflare.tunnel}" = {
        ingress = {
          "jellyseerr.${server.domain}" = "http://127.0.0.1:5055";
        };
      };
    };
  };
}
