_: {
  flake.modules.nixos.tank = {
    services.rpcbind.enable = true; # Required for NFS
    boot.supportedFilesystems = ["nfs"]; # Ensure kernel module loads
    systemd.targets.network-online.enable = true;

    # Mount configurations
    # TODO: Consider adding x-systemd.automount for on-demand mounting
    # Requires adding "noauto" alongside automount option
    # Benefits: faster boot, auto-retry on connection drops, on-demand access
    fileSystems = {
      "/mnt/downloads" = {
        device = "thor:/downloads";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4" "x-systemd.after=tailscaled.service" "x-systemd.requires=tailscaled.service"];
      };
      "/mnt/media" = {
        device = "thor:/media";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4" "ro" "x-systemd.after=tailscaled.service" "x-systemd.requires=tailscaled.service"];
      };
      "/mnt/backup" = {
        device = "thor:/backup";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4" "x-systemd.after=tailscaled.service" "x-systemd.requires=tailscaled.service"];
      };
      "/mnt/share" = {
        device = "thor:/share";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4" "x-systemd.after=tailscaled.service" "x-systemd.requires=tailscaled.service"];
      };
    };
  };
}
