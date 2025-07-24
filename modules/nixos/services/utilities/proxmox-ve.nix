{
  config,
  lib,
  inputs,
  system,
  ...
}:
with lib; let
  cfg = config.services.proxmox-ve;
in {
  options.services.proxmox-ve = {
    url = mkOption {
      type = types.str;
      default = "pve.${config.homelab.domain}";
    };
  };

  config = mkMerge [
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        inputs.proxmox-nixos.overlays.${system}
      ];
    }
    (mkIf cfg.enable {
      networking.bridges.vmbr0.interfaces = ["eno1"];
      networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;

      services = {
        proxmox-ve = {
          ipAddress = "${config.homelab.ip}";
          bridges = ["vmbr0"];
        };

        nginx.virtualHosts."${cfg.url}" = {
          locations."/" = {
            proxyPass = "https://127.0.0.1:8006";
            proxyWebsockets = true;
            extraConfig = ''
              # Cloudflare tunnel compatibility headers
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-Server $host;

              # Proxy timeouts for long-running connections
              proxy_connect_timeout 60s;
              proxy_send_timeout 60s;
              proxy_read_timeout 60s;

              # Buffer settings for better performance
              proxy_buffering off;
              proxy_request_buffering off;

              # SSL verification bypass for self-signed certs
              proxy_ssl_verify off;
              proxy_ssl_server_name on;

              # Security headers
              add_header X-Frame-Options SAMEORIGIN;
              add_header X-Content-Type-Options nosniff;
              add_header X-XSS-Protection "1; mode=block";
            '';
          };
        };
      };
    })
  ];
}
