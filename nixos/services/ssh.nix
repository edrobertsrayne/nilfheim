{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkEnableOption "Whether to enable SSH.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
