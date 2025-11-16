_: {
  flake.modules.nixos.thor = {lib, ...}: let
    ipAddress = "192.168.68.108";
  in {
    # imports = [inputs.self.modules.nixos.proxmox];

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

    # Proxmox configuration
    # services.proxmox-ve = {
    #   ipAddress = "192.168.68.108";
    #   bridges = ["vmbr0"];
    # };
  };
}
