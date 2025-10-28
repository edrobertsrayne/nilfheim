{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
in {
  flake.modules.nixos.home-assistant = {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        volumes = [
          "/srv/homeassistant:/config"
        ];
        extraOptions = [
          "--network=host"
          "--pull=always"
        ];
      };
    };
    systemd.tmpfiles.rules = [
      "d /srv/homeassistant 0755 root root"
    ];
    services.cloudflared = {
      tunnels."${server.cloudflare.tunnel}" = {
        ingress = {
          "home.${server.domain}" = "http://127.0.0.1:8123";
        };
      };
    };
  };
}
