{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
in {
  flake.modules.nixos.media = {
    services.jellyseerr.enable = true;

    flake.nilfheim.server.proxy.services.jellyseerr = {
      subdomain = "jellyseerr.${server.domain}";
      port = 5055;
    };
  };
}
