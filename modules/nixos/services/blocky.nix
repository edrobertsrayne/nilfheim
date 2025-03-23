{
  config,
  lib,
  ...
}: let
  cfg = config.nixos.services.blocky;
  inherit (lib) mkEnableOption mkIf;
in {
  options.nixos.services.blocky = {
    enable = mkEnableOption "Whether to enable blocky ad blocking servce.";
  };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;
    };
  };
}
