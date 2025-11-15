{inputs, ...}: {
  flake.modules.nixos.thor = {lib, ...}: {
    imports = [inputs.self.modules.nixos.proxmox];

    # Override NetworkManager with systemd-networkd for bridge support
    networking = {
      networkmanager.enable = lib.mkForce false;
      useNetworkd = true;
      # Trust bridge interface
      firewall.trustedInterfaces = ["vmbr0"];
    };

    # Proxmox configuration
    services.proxmox-ve = {
      ipAddress = "192.168.68.108";
      bridges = ["vmbr0"];
    };

    # Disable bridge netfilter to allow L2 forwarding without iptables interference
    boot.kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = 0;
      "net.bridge.bridge-nf-call-ip6tables" = 0;
      "net.bridge.bridge-nf-call-arptables" = 0;
    };

    # Systemd configuration for network and SSH ordering
    systemd = {
      # Ensure SSH waits for network to be ready
      services = {
        sshd = {
          after = ["systemd-networkd-wait-online.service"];
          wants = ["systemd-networkd-wait-online.service"];
        };

        systemd-networkd-wait-online = {
          enable = true;
          serviceConfig.ExecStart = [
            "" # Clear default
            "systemd-networkd-wait-online -i vmbr0" # Wait for bridge only
          ];
        };
      };

      # Network bridge configuration
      network = {
        enable = true;
        wait-online.enable = true;

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
            networkConfig = {
              Bridge = "vmbr0";
              LinkLocalAddressing = "no";
            };
            linkConfig = {
              RequiredForOnline = "enslaved";
              Promiscuous = true;
            };
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
  };
}
