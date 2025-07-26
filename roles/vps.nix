{lib, ...}: {
  imports = [./server.nix];

  networking.firewall.allowedTCPPorts = [80 443 3000 8080];
  networking.firewall.allowedUDPPorts = [443];
  system.persist.extraRootDirectories = ["/etc/dokploy" "/var/lib/docker"];
  virtualisation = {
    docker.rootless.enable = lib.mkForce false;
    oci-containers = {
      backend = "docker";
      containers = {
        portainer = {
          image = "portainer/portainer-ce:latest";
          volumes = [
            "portainer_data:/data"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
          ports = [
            "9443:9443"
            "8000:8000"
          ];
          autoStart = true;
          extraOptions = [
            "--pull=always"
          ];
        };
      };
    };
  };
}
