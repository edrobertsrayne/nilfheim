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
    flake.nilfheim.server.proxy.services.home-assistant = {
      subdomain = "home.${server.domain}";
      port = 8123;
    };
  };
}
