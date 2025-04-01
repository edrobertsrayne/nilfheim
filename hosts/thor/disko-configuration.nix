{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-SK_hynix_BC501_HFM256GDJTNG-8310A_NS97N486611407A37";
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
        device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_4TB_S6BCNF0W304378R";
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
          "local/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "false";
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/local/root@blank$' || zfs snapshot zroot/local/root@blank";
          };
        };
      };
      tank = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "zstd"; # Optimized for space (media/backups)
          mountpoint = "none";
          xattr = "sa";
        };
        options.ashift = "12";

        datasets = {
          "media" = {
            type = "zfs_fs";
            mountpoint = "/mnt/media";
            options."com.sun:auto-snapshot" = "false";
          };
          "backup" = {
            type = "zfs_fs";
            mountpoint = "/mnt/backup";
            options."com.sun:auto-snapshot" = "false";
          };
        };
      };
    };
  };
}
