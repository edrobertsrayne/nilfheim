{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
in {
  flake.modules.nixos.portainer = {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.portainer = {
        image = "portainer/portainer-ce:latest";
        autoStart = true;

        ports = [
          "9443:9443"
          "9000:9000"
          "8000:8000"
        ];

        volumes = [
          "portainer_data:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];

        extraOptions = [
          "--pull=always"
        ];
      };
    };

    flake.nilfheim.server.proxy.services.portainer = {
      subdomain = "portainer.${server.domain}";
      port = 9000;
    };
  };
}
