_: {
  flake.modules.nixos.tank = {
    services.rpcbind.enable = true; # Required for NFS
    boot.supportedFilesystems = ["nfs"]; # Ensure kernel module loads
    systemd.targets.network-online.enable = true;

    # Mount configurations
    fileSystems = {
      "/mnt/downloads" = {
        device = "thor:/downloads";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4"];
      };
      "/mnt/media" = {
        device = "thor:/media";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4" "ro"];
      };
      "/mnt/backup" = {
        device = "thor:/backup";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4"];
      };
      "/mnt/share" = {
        device = "thor:/share";
        fsType = "nfs4";
        options = ["soft" "intr" "bg" "vers=4"];
      };
    };
  };
}
