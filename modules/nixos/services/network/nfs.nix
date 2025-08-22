{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.nfs-server;
  clientCfg = config.services.nfs-client;
  constants = import ../../../../lib/constants.nix;
in {
  options = {
    services.nfs-server = {
      enable = mkEnableOption "NFS server with tailscale network support";

      network = mkOption {
        type = types.str;
        default = "100.64.0.0/10";
        description = "Network CIDR for NFS exports (tailscale CGNAT range)";
      };

      shares = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            source = mkOption {
              type = types.path;
              description = "Source directory to export";
            };
            permissions = mkOption {
              type = types.enum ["ro" "rw"];
              default = "ro";
              description = "Export permissions (read-only or read-write)";
            };
          };
        });
        default = {};
        description = "NFS shares configuration";
      };
    };

    services.nfs-client = {
      enable = mkEnableOption "NFS client with automatic mounting";

      server = mkOption {
        type = types.str;
        description = "NFS server hostname or IP address";
      };

      mounts = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            remotePath = mkOption {
              type = types.str;
              description = "Remote NFS path to mount";
            };
            localPath = mkOption {
              type = types.path;
              description = "Local mount point";
            };
            options = mkOption {
              type = types.listOf types.str;
              default = ["soft" "intr" "bg" "vers=4"];
              description = "NFS mount options";
            };
          };
        });
        default = {};
        description = "NFS mounts configuration";
      };
    };
  };

  config = mkMerge [
    # NFS Server Configuration
    (mkIf cfg.enable {
      # Create export directories
      systemd.tmpfiles.rules =
        ["d /export 0755 nobody nogroup -"]
        ++ (builtins.attrValues (builtins.mapAttrs (
            name: _: "d /export/${name} 0755 nobody nogroup -"
          )
          cfg.shares));

      # Configure services
      services = {
        nfs.server = {
          enable = true;
          statdPort = constants.ports.nfs-status;
          exports = let
            rootExport = "/export ${cfg.network}(rw,fsid=0,no_subtree_check)";
            shareExports = builtins.attrValues (builtins.mapAttrs (
                name: share: "/export/${name} ${cfg.network}(${share.permissions},nohide,insecure,no_subtree_check)"
              )
              cfg.shares);
          in
            builtins.concatStringsSep "\n" ([rootExport] ++ shareExports);
        };
        rpcbind.enable = true;
      };

      # Bind mount source directories to export points
      fileSystems = builtins.listToAttrs (builtins.attrValues (builtins.mapAttrs (name: share: {
          name = "/export/${name}";
          value = {
            device = toString share.source;
            options = ["bind"];
          };
        })
        cfg.shares));

      # Configure firewall for NFS
      networking.firewall = {
        allowedTCPPorts = [
          constants.ports.nfs
          constants.ports.rpcbind
          constants.ports.nfs-status
        ];
        allowedUDPPorts = [
          constants.ports.rpcbind
        ];
      };
    })

    # NFS Client Configuration
    (mkIf clientCfg.enable {
      # Enable NFS client support
      services.rpcbind.enable = true;

      # Configure file systems for NFS mounts
      fileSystems = builtins.listToAttrs (builtins.attrValues (builtins.mapAttrs (name: mount: {
          name = mount.localPath;
          value = {
            device = "${clientCfg.server}:${mount.remotePath}";
            fsType = "nfs4";
            inherit (mount) options;
          };
        })
        clientCfg.mounts));

      # Create mount point directories
      systemd.tmpfiles.rules = builtins.attrValues (builtins.mapAttrs (
          name: mount: "d ${mount.localPath} 0755 root root -"
        )
        clientCfg.mounts);

      # Enable network wait for NFS mounts
      systemd.targets.network-online.wantedBy = ["multi-user.target"];
    })
  ];
}
