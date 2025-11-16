{inputs, ...}: {
  flake.modules.nixos.proxmox = {config, ...}: {
    imports = [inputs.proxmox-nixos.nixosModules.proxmox-ve];

    # Apply overlay to make proxmox packages available
    nixpkgs.overlays = [inputs.proxmox-nixos.overlays.x86_64-linux];

    services.proxmox-ve = {
      enable = true;
    };

    # Binary cache for faster builds
    nix.settings = {
      substituters = ["https://cache.saumon.network/proxmox-nixos"];
      trusted-public-keys = ["proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="];
    };

    # Proxmox requires systemd-networkd, not NetworkManager
    assertions = [
      {
        assertion = !config.networking.networkmanager.enable;
        message = "Proxmox requires systemd-networkd. Disable NetworkManager in host config.";
      }
    ];

    # Open Proxmox web UI port
    networking.firewall.allowedTCPPorts = [8006];

    # VM storage directory
    systemd.tmpfiles.rules = [
      "d /srv/proxmox 0755 root root -"
    ];
  };
}
