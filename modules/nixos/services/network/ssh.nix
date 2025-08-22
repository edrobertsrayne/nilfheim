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
        # Enhanced security hardening
        MaxAuthTries = 3;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
        Protocol = 2;
        X11Forwarding = false;
        UsePAM = true;
        PermitEmptyPasswords = false;
        ChallengeResponseAuthentication = false;
        KbdInteractiveAuthentication = false;
        UseDns = false;
      };
    };
  };
}
