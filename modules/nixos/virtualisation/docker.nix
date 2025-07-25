{
  config,
  lib,
  username,
  ...
}:
with lib; let
  cfg = config.virtualisation.docker;
in {
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enableOnBoot = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    users.users.${username}.extraGroups = ["docker"];
  };
}
