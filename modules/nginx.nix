_: {
  flake.modules.nixos.nginx = {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      # WebSocket upgrade support
      appendHttpConfig = ''
        map $http_upgrade $connection_upgrade {
          default upgrade;
          "" close;
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
