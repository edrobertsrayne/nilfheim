{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.system.persist;
  inherit (config.modules.user) name;

  # Define base directories and files to persist
  baseRootDirectories = [
    "/etc/nixos"
    "/var/log"
    "/var/lib/bluetooth"
    "/var/lib/nixos"
    "/var/lib/systemd/coredump"
    # "/etc/NetworkManager/system-connections"
    "/etc/ssh/authorized_keys.d"
  ];

  baseRootFiles = [
    "/etc/machine-id"
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_rsa_key.pub"
  ];

  baseUserDirectories = [
    "Desktop"
    "Documents"
    "Music"
    "Pictures"
    "Projects"
    "Public"
    "Templates"
    "Videos"
    {
      directory = ".gnupg";
      mode = "0700";
    }
    {
      directory = ".ssh";
      mode = "0700";
    }
    {
      directory = ".local/share/keyrings";
      mode = "0700";
    }
    ".local/share/direnv"
    ".local/share/zoxide"
    ".tmux/resurrect"
  ];

  baseUserFiles = [
    ".screenrc"
  ];
in {
  options.modules.system.persist = with types; {
    enable = mkEnableOption "Whether to enable peristent storage";
    path = mkOption {
      type = str;
      default = "/persist";
      description = "Path to persistent storage location";
    };
    filesystem = mkOption {
      type = types.enum ["zfs" "btrfs" "other"];
      default = "btrfs";
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
      example = literalExpression ''
        [
          "/var/lib/docker"
          {
            directory = "/var/lib/jenkins";
            user = "jenkins";
            group = "jenkins";
            mode = "u=rwx,g=rx,o=";
          }
        ]
      '';
    };
    extraRootFiles = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [];
      description = "Additional system files to persist";
      example = literalExpression ''
        [
          "/etc/adjtime"
          {
            file = "/etc/special.conf";
            parentDirectory = { mode = "u=rwx,g=,o="; };
          }
        ]
      '';
    };
    extraUserDirectories = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [];
      description = "Additional directories to persist for the primary user";
      example = literalExpression ''
        [
          ".config/vscode"
          {
            directory = ".local/share/applications";
            mode = "0755";
          }
        ]
      '';
    };
    extraUserFiles = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [];
      description = "Additional files to persist for the primary user";
      example = literalExpression ''
        [
          ".zsh_history"
          {
            file = ".config/special.conf";
            parentDirectory = { mode = "0700"; };
          }
        ]
      '';
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
        users.${name} = {
          directories = baseUserDirectories ++ cfg.extraUserDirectories;
          files = baseUserFiles ++ cfg.extraUserFiles;
        };
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
