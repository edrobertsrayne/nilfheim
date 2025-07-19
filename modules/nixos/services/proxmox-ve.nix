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
        };

        nginx.virtualHosts."${cfg.url}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8006";
          };
        };
      };
    })
  ];
}
