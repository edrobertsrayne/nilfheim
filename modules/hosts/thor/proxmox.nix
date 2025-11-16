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

    # Enable IP forwarding and disable bridge netfilter
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.bridge.bridge-nf-call-iptables" = 0;
      "net.bridge.bridge-nf-call-ip6tables" = 0;
      "net.bridge.bridge-nf-call-arptables" = 0;
    };

    # Minimal network bridge configuration
    systemd.network = {
      enable = true;
      networks = {
        "10-lan" = {
          matchConfig.Name = "eno1";
          networkConfig.Bridge = "vmbr0";
        };

        "10-lan-bridge" = {
          matchConfig.Name = "vmbr0";
          networkConfig = {
            IPv6AcceptRA = true;
            DHCP = "ipv4";
          };
          linkConfig.RequiredForOnline = "routable";
        };
      };
      netdevs."vmbr0" = {
        netdevConfig = {
          Name = "vmbr0";
          Kind = "bridge";
        };
      };
    };
  };
}
