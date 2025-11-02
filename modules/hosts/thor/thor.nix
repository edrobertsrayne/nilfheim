{inputs, ...}: {
  flake = {
    nilfheim.server.cloudflare = {
      tunnel = "23c4423f-ec30-423b-ba18-ba18904ddb85";
      secret = ../../../secrets/cloudflare-thor.age;
    };

    modules.nixos.thor = {
      imports = with inputs.self.modules.nixos; [
        portainer
        blocky
        media
        cloudflared
        home-assistant
      ];

      boot.supportedFilesystems = ["zfs"];
      boot.zfs.extraPools = ["tank"];
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

    modules.homeManager.thor = {
      imports = with inputs.self.modules.homeManager; [
        utilities
      ];
    };
  };
}
