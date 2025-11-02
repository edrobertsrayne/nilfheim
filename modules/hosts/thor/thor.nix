{inputs, ...}: {
  flake = {
    nilfheim.server.cloudflare = {
      tunnel = "23c4423f-ec30-423b-ba18-ba18904ddb85";
      secret = ../../../secrets/cloudflare-thor.age;
    };

    modules.nixos.thor = {
      imports = with inputs.self.modules.nixos; [
        ./_disko.nix
        ./_hardware-configuration.nix

        zsh
        portainer
        blocky
        media
        cloudflared
        home-assistant
      ];
      # Ensure ZFS is set up properly
      boot.supportedFilesystems = ["zfs"];
      boot.zfs.extraPools = ["tank"];

      # Create tank group and add main user
      users.groups.tank.members = ["${inputs.self.nilfheim.user.username}"];

      services.tailscale = {
        useRoutingFeatures = "server";
        extraUpFlags = [
          "--exit-node=100.84.2.120"
          "--exit-node-allow-lan-access=true"
          ''--advertise-routes "192.168.68.0/24"''
        ];
      };

      virtualisation.docker.daemon.settings = {
        data-root = "/srv/docker";
      };
    };

    modules.generic.thor = {
      imports = with inputs.self.modules.generic; [
        # CLI tools
        utilities
      ];
    };
  };
}
