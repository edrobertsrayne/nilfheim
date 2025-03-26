{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.foot;
  inherit (config.modules) user;
in {
  options.desktop.foot = with types; {
    enable = mkBoolOpt false "Whether to enable foot terminal emulator.";
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
          url.protocols = "http,https,ftp,ftps,file,gemini,gopher,mailto";
          cursor = {
            color = "11111b f5e0dc";
            blink = "yes";
          };
          csd.size = 0;
          colors = {
            foreground = "cdd6f4";
            background = "1e1e2e";
            regular0 = "45475a";
            regular1 = "f38ba8";
            regular2 = "a6e3a1";
            regular3 = "f9e2af";
            regular4 = "89b4fa";
            regular5 = "f5c2e7";
            regular6 = "94e2d5";
            regular7 = "bac2de";
            bright1 = "f38ba8";
            bright2 = "a6e3a1";
            bright3 = "f9e2af";
            bright4 = "89b4fa";
            bright5 = "f5c2e7";
            bright6 = "94e2d5";
            bright7 = "a6adc8";
            "16" = "fab387";
            "17" = "f5e0dc";
            selection-foreground = "cdd6f4";
            selection-background = "414356";
            search-box-no-match = "11111b f38ba8";
            search-box-match = "cdd6f4 313244";
            jump-labels = "11111b fab387";
            urls = "89b4fa";
          };
        };
      };
    };
  };
}
