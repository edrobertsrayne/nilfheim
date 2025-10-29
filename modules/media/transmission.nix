{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
in {
  flake.modules.nixos.media = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.services.transmission;
  in {
    users.users.${cfg.user}.extraGroups = ["tank"];

    systemd.tmpfiles.rules = [
      "d ${cfg.settings.incomplete-dir} 0755 ${cfg.user} tank -"
    ];

    services.transmission = {
      enable = true;
      home = lib.mkDefault "/srv/transmission";
      package = pkgs.transmission_4;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-port = 9091;
        peer-port = 51413;
        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;

        download-dir = "/mnt/downloads";
        incomplete-dir = "/mnt/downloads/incomplete";

        ratio-limit-enabled = true;
        ratio-limit = 2.0;
        seed-queue-enabled = true;
        seed-queue-size = 5;

        download-queue-enabled = true;
        download-queue-size = 10;
        queue-stalled-enabled = true;
        queue-stalled-minutes = 30;

        cache-size-mb = 16;
        prefetch-enabled = true;

        dht-enabled = true;
        lpd-enabled = false;
        pex-enabled = true;
        utp-enabled = true;

        alt-speed-enabled = false;

        blocklist-enabled = false;
      };
    };

    networking.firewall.allowedTCPPorts = [
      cfg.settings.rpc-port
      cfg.settings.peer-port
    ];

    services.cloudflared = {
      tunnels."${server.cloudflare.tunnel}" = {
        ingress = {
          "transmission.${server.domain}" = "http://127.0.0.1:${builtins.toString cfg.settings.rpc-port}";
        };
      };
    };
  };
}
