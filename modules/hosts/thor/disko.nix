_: {
  flake.modules.nixos.thor = {
    disko.devices = {
      disk = {
        nvme0 = {
          device = "/dev/nvme0n1";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
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
        nvme1 = {
          device = "/dev/nvme1n1";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot-fallback";
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
        disk1 = {
          device = "/dev/sdb";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              data = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/mnt/disk1";
                  mountOptions = ["defaults"];
                };
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
          mode = "mirror";
          rootFsOptions = {
            acltype = "posixacl";
            atime = "off";
            compression = "lz4";
            xattr = "sa";
          };
          options.ashift = "12";

          datasets = {
            srv = {
              type = "zfs_fs";
              mountpoint = "/srv";
              options."com.sun:auto-snapshot" = "true";
            };
            nix = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options."com.sun:auto-snapshot" = "false";
            };
            root = {
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
