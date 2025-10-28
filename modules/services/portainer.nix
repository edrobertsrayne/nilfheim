{inputs, ...}: {
  flake.modules.nixos.portainer = {
    virtualisation = {
      oci-containers = {
        backend = "docker";
        containers.portainer = {
          image = "portainer/portainer-ce:latest";
          autoStart = true;

          ports = let
            inherit (inputs.self.lib) constants;
          in [
            "${toString constants.ports.portainer}:9443"
            "${toString constants.ports.portainer-http}:9000"
            "${toString constants.ports.portainer-agent}:8000"
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
    };
  };
}
