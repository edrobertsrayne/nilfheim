_: {
  flake.modules.nixos.thor = {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/nvme0n1";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              ESP = {
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
        tank = {
          device = "/dev/sda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
          rootFsOptions = {
            acltype = "posixacl";
            atime = "off";
            compression = "lz4"; # Optimized for speed (OS workloads)
            mountpoint = "none";
            xattr = "sa";
          };
          options.ashift = "12";

          datasets = {
            "local" = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "local/srv" = {
              type = "zfs_fs";
              mountpoint = "/srv";
              options."com.sun:auto-snapshot" = "true";
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options."com.sun:auto-snapshot" = "false";
            };
            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
              options."com.sun:auto-snapshot" = "false";
            };
          };
        };
        tank = {
          type = "zpool";
          rootFsOptions = {
            acltype = "posixacl";
            atime = "off";
            compression = "zstd";
            mountpoint = "none";
            xattr = "sa";
          };
          options.ashift = "12";
          datasets = {
            "backup" = {
              type = "zfs_fs";
              mountpoint = "/mnt/backup";
              options."com.sun:auto-snapshot" = "false";
              mountOptions = ["nofail"];
            };
            "share" = {
              type = "zfs_fs";
              mountpoint = "/mnt/share";
              options."com.sun:auto-snapshot" = "false";
              mountOptions = ["nofail"];
            };
            "media" = {
              type = "zfs_fs";
              mountpoint = "/mnt/media";
              options."com.sun:auto-snapshot" = "false";
              mountOptions = ["nofail"];
            };
            "downloads" = {
              type = "zfs_fs";
              mountpoint = "/mnt/downloads";
              options."com.sun:auto-snapshot" = "false";
              mountOptions = ["nofail"];
            };
          };
        };
      };
    };
  };
}
