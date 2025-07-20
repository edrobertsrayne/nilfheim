{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.ssh;
in {
  options.services.ssh = {
    enable = mkEnableOption "Whether to enable SSH service.";
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
