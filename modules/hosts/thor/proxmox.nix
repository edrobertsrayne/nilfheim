{inputs, ...}: {
  flake.modules.nixos.thor = {lib, ...}: {
    imports = [inputs.self.modules.nixos.proxmox];

    # Override NetworkManager with systemd-networkd for bridge support
    networking = {
      networkmanager.enable = lib.mkForce false;
      useNetworkd = true;
    };

    # Proxmox configuration
    services.proxmox-ve = {
      ipAddress = "192.168.68.108";
      bridges = ["vmbr0"];
    };

    # Network bridge configuration
    systemd.network = {
      enable = true;

      # Create bridge device
      netdevs."10-vmbr0" = {
        netdevConfig = {
          Name = "vmbr0";
          Kind = "bridge";
        };
      };

      networks = {
        # Attach physical interface to bridge
        "20-eno1" = {
          matchConfig.Name = "eno1";
          networkConfig.Bridge = "vmbr0";
          linkConfig.RequiredForOnline = "enslaved";
        };

        # Configure bridge with static IP
        "30-vmbr0" = {
          matchConfig.Name = "vmbr0";
          networkConfig = {
            Address = "192.168.68.108/22";
            Gateway = "192.168.68.1";
            DNS = "127.0.0.1";
            IPv6AcceptRA = true;
          };
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
  };
}
