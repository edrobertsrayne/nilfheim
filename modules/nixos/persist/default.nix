{
  lib,
  config,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.persist;
  inherit (config.${namespace}.user) name;
in {
  options.${namespace}.persist = with types; {
    enable = mkEnableOption "Whether to enable peristent storage";
    path = mkOption {
      type = str;
      default = "/persist";
      description = "Path to persistent storage location";
    };
  };
  config = mkIf cfg.enable {
    fileSystems.${cfg.path}.neededForBoot = true;
    environment.persistence.${cfg.path} = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory = {mode = "u=rwx,g=,o=";};
        }
      ];
      users.${name} = {
        directories = [
          "Music"
          "Pictures"
          "Documents"
          "Projects"
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
          ".config/gh"
        ];
        files = [
          ".screenrc"
        ];
      };
    };
  };
}
