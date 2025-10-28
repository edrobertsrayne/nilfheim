{...}: {
  flake.modules.nixos.thor = {
    # Create /export directory structure
    systemd.tmpfiles.rules = [
      "d /export 0755 nobody nogroup -"
      "d /export/downloads 0755 nobody nogroup -"
      "d /export/media 0755 nobody nogroup -"
      "d /export/backup 0755 nobody nogroup -"
      "d /export/share 0755 nobody nogroup -"
    ];

    # Bind mount ZFS paths to export points
    fileSystems = {
      "/export/downloads" = {
        device = "/mnt/downloads";
        options = ["bind"];
      };
      "/export/media" = {
        device = "/mnt/media";
        options = ["bind"];
      };
      "/export/backup" = {
        device = "/mnt/backup";
        options = ["bind"];
      };
      "/export/share" = {
        device = "/mnt/share";
        options = ["bind"];
      };
    };

    # Configure NFS server
    services.nfs.server = {
      enable = true;
      exports = ''
        /export 100.64.0.0/10(rw,fsid=0,no_subtree_check)
        /export/downloads 100.64.0.0/10(rw,nohide,insecure,no_subtree_check)
        /export/media 100.64.0.0/10(ro,nohide,insecure,no_subtree_check)
        /export/backup 100.64.0.0/10(rw,nohide,insecure,no_subtree_check)
        /export/share 100.64.0.0/10(rw,nohide,insecure,no_subtree_check)
      '';
    };

    services.rpcbind.enable = true;
    networking.firewall = {
      allowedTCPPorts = [111 2049 4000 4001 4002 20048];
      allowedUDPPorts = [111 2049 4000 4001 4002 20048];
    };
  };
}
