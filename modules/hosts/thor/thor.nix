{inputs, ...}: {
  flake = let
    tunnel = "23c4423f-ec30-423b-ba18-ba18904ddb85";
    secret = ../../../secrets/cloudflare-thor.age;
    inherit (inputs.self.niflheim.server) domain;
  in {
    modules.nixos.thor = {config, ...}: {
      imports = with inputs.self.modules.nixos; [
        nginx
        portainer
        blocky
        media
        home-assistant
        karakeep
      ];

      boot.supportedFilesystems = ["zfs"];
      boot.zfs.extraPools = ["tank"];
      users.groups.tank.members = ["${inputs.self.niflheim.user.username}"];

      age.secrets.cloudflared.file = secret;
      services.cloudflared = {
        enable = true;
        tunnels."${tunnel}" = {
          credentialsFile = config.age.secrets.cloudflared.path;
          default = "http_status:404";
          ingress = {
            "*.${domain}" = "http://127.0.0.1:80";
          };
        };
      };

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
