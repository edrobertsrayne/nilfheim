{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.firefox;
  inherit (config.modules) user;
in {
  options.modules.desktop.firefox.enable = mkEnableOption "Whether to enable Firefox browser.";

  config = mkIf cfg.enable {
    home-manager.users.${user.name}.config = {
      programs.firefox = {enable = true;};
    };
  };
}
