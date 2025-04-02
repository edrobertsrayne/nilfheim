{
  lib,
  username,
  ...
}: let
  # Helper function to generate ZFS tank dataset configurations
  mkTankMount = name: {
    "${name}" = {
      type = "zfs_fs";
      mountpoint = "/mnt/${name}";
      options."com.sun:auto-snapshot" = "false";
      mountOptions = ["nofail"];
    };
  };

  # List of tank datasets
  tankDatasets = [
    "backup"
    "downloads"
    "media"
    "share"
  ];

  # Generate permissions script for tank mounts
  mkTankPermissions = dirs:
    lib.concatMapStrings (dir: ''
      if [ -d "/mnt/${dir}" ]; then
        chown -R ${username}:tank /mnt/${dir}
        chmod -R 2775 /mnt/${dir}
      fi
    '')
    dirs;
in {
  users.groups.tank.members = ["${username}"];

  # Ensure ZFS is set up properly
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["tank"];

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
          compression = "zstd";
          mountpoint = "none";
          xattr = "sa";
        };
        options.ashift = "12";
        datasets = lib.foldl (acc: name: acc // mkTankMount name) {} tankDatasets;
      };
    };
  };

  # Setup permissions
  system.activationScripts.tankPermissions = {
    deps = ["users" "groups"];
    text = ''
      echo "Setting up tank pool permissions..."
      ${mkTankPermissions tankDatasets}
    '';
  };
}
