{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.firefox;
in {
  options.desktop.firefox = {
    enable = mkEnableOption "Whether to enable Firefox browser.";
    defaultBrowser = mkBoolOpt true "Whether to set Firefox as the default browser.";
  };

  config =
    mkIf cfg.enable
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox;
      };
      xdg.mime.defaultApplications = mkIf cfg.defaultBrowser {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
}
