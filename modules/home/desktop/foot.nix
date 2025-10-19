{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.foot;
in {
  options.desktop.foot = {
    enable = mkEnableOption "Whether to enable foot terminal emulator.";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = false;
      settings = {
        main = {
          line-height = 14;
          underline-offset = 2;
          pad = "0x0 center";
          term = "xterm-256color";
        };
        scrollback.lines = 2000;
        cursor = {
          blink = "yes";
        };
        csd.size = 0;
      };
    };
  };
}
