{inputs, ...}: let
  inherit (inputs.self.niflheim) server;
in {
  flake.modules.nixos.thor = {lib, ...}: let
    ipAddress = "192.168.68.108";
  in {
    imports = [inputs.self.modules.nixos.proxmox];

    networking = {
      networkmanager.enable = lib.mkForce false;
      useDHCP = false;
      bridges = {
        "vmbr0" = {
          interfaces = ["eno1"];
        };
      };
      interfaces.vmbr0.ipv4.addresses = [
        {
          address = ipAddress;
          prefixLength = 22;
        }
      ];
      defaultGateway = "192.168.68.1";
      nameservers = ["1.1.1.1" "8.8.8.8"];
    };

    services.proxmox-ve = {
      inherit ipAddress;
      bridges = ["vmbr0"];
    };

    services.nginx.virtualHosts."proxmox.${server.domain}" = {
      locations."/" = {
        proxyPass = "https://127.0.0.1:8006";
        proxyWebsockets = true;
      };
    };
  };
}
