_: {
  flake.modules.nixos.nfs-client = {
    services.rpcbind.enable = true; # Required for NFS
    boot.supportedFilesystems = ["nfs"]; # Ensure kernel module loads
    systemd.targets.network-online.enable = true;

    # Mount configurations using systemd automount for reliability
    # Mounts happen on-demand (first access) instead of at boot
    # Benefits: faster boot, auto-retry on connection drops, no boot blocking
    fileSystems = {
      "/mnt/downloads" = {
        device = "thor:/downloads";
        fsType = "nfs4";
        options = [
          "soft"
          "intr"
          "bg"
          "vers=4"
          "noauto"
          "x-systemd.automount"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=30"
        ];
      };
      "/mnt/media" = {
        device = "thor:/media";
        fsType = "nfs4";
        options = [
          "soft"
          "intr"
          "bg"
          "vers=4"
          "ro"
          "noauto"
          "x-systemd.automount"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=30"
        ];
      };
      "/mnt/backup" = {
        device = "thor:/backup";
        fsType = "nfs4";
        options = [
          "soft"
          "intr"
          "bg"
          "vers=4"
          "noauto"
          "x-systemd.automount"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=30"
        ];
      };
      "/mnt/share" = {
        device = "thor:/share";
        fsType = "nfs4";
        options = [
          "soft"
          "intr"
          "bg"
          "vers=4"
          "noauto"
          "x-systemd.automount"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=30"
        ];
      };
    };
  };
}
