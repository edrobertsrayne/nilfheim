{
  imports = [./server.nix];

  virtualisation.oci-containers.containers = {
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
        "--restart=unless-stopped"
      ];
    };
  };
}
