{inputs, ...}: let
  inherit (inputs.self.niflheim) server;
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

    services.nginx.virtualHosts."portainer.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:9000";
        proxyWebsockets = true;
      };
    };
  };
}
