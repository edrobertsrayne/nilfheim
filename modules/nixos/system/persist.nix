{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.persist;

  baseRootDirectories = [
    "/etc/nixos"
    "/var/log"
    "/var/lib/bluetooth"
    "/var/lib/nixos"
    "/var/lib/systemd/coredump"
    "/etc/NetworkManager/system-connections"
    "/etc/ssh/authorized_keys.d"
  ];

  baseRootFiles = [
    "/etc/machine-id"
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_rsa_key.pub"
  ];
in {
  options.system.persist = with types; {
    enable = mkEnableOption "Whether to enable peristent storage";
    path = mkOption {
      type = str;
      default = "/persist";
      description = "Path to persistent storage location";
    };
    filesystem = mkOption {
      type = types.enum ["zfs" "btrfs" "other"];
      default = "zfs";
      description = "Filesystem type for root";
    };
    rootVolume = mkOption {
      type = str;
      default = "/dev/root_vg/root";
      description = "Path to the root volume device";
    };
    oldRootsRetentionDays = mkOption {
      type = int;
      default = 30;
      description = "Number of days to keep old root snapshots";
    };
    tmpMountPoint = mkOption {
      type = str;
      default = "/btrfs_tmp";
      description = "Temporary mount point for BTRFS operations";
    };
    extraRootDirectories = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [];
      description = "Additional system directories to persist";
    };
    extraRootFiles = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [];
      description = "Additional system files to persist";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      fileSystems = {
        ${cfg.path}.neededForBoot = true;
      };
      environment.persistence.${cfg.path} = {
        hideMounts = true;
        directories = baseRootDirectories ++ cfg.extraRootDirectories;
        files = baseRootFiles ++ cfg.extraRootFiles;
      };
      services.openssh = {
        hostKeys = [
          {
            path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
          {
            path = "/persist/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
            bits = 4096;
          }
        ];
      };
    }

    (mkIf (cfg.filesystem == "btrfs") {
      boot.initrd.postDeviceCommands =
        lib.mkAfter
        /*
        bash
        */
        ''
          mkdir ${cfg.tmpMountPoint}
          mount ${cfg.rootVolume} ${cfg.tmpMountPoint}
          if [[ -e ${cfg.tmpMountPoint}/root ]]; then
              mkdir -p ${cfg.tmpMountPoint}/old_roots
              timestamp=$(date --date="@$(stat -c %Y ${cfg.tmpMountPoint}/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv ${cfg.tmpMountPoint}/root "${cfg.tmpMountPoint}/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "${cfg.tmpMountPoint}/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find ${cfg.tmpMountPoint}/old_roots/ -maxdepth 1 -mtime +${toString cfg.oldRootsRetentionDays}); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create ${cfg.tmpMountPoint}/root
          umount ${cfg.tmpMountPoint}
        '';
    })

    (mkIf (cfg.filesystem == "zfs") {
      boot.initrd = {
        availableKernelModules = ["zfs"];
        kernelModules = ["zfs"];
        supportedFilesystems = ["zfs"];
        postDeviceCommands = lib.mkAfter ''
          zpool import -N zroot
          zfs rollback -r zroot/local/root@blank
        '';
      };
      networking.hostId = builtins.substring 0 8 (
        builtins.hashString "sha256" config.networking.hostName
      );
      services.zfs = {
        autoScrub.enable = true;
        trim.enable = true;
      };
    })
  ]);
}
