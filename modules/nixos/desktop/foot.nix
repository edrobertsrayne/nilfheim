{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.foot;
  inherit (config) user;
in {
  options.desktop.foot = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable foot terminal emulator.";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name}.config = {
      programs.foot = {
        enable = true;
        server.enable = false;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:size=12";
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
  };
}
