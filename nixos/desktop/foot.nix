{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.desktop.foot;
  inherit (config.modules) user;
  themes.rose-pine.colors = {
    background = "191724";
    foreground = "e0def4";
    regular0 = "26233a"; # black (Overlay)
    regular1 = "eb6f92"; # red (Love)
    regular2 = "9ccfd8"; # green (Foam)
    regular3 = "f6c177"; # yellow (Gold)
    regular4 = "31748f"; # blue (Pine)
    regular5 = "c4a7e7"; # magenta (Iris)
    regular6 = "ebbcba"; # cyan (Rose)
    regular7 = "e0def4"; # white (Text)
    bright0 = "47435d"; # bright black (lighter Overlay)
    bright1 = "ff98ba"; # bright red (lighter Love)
    bright2 = "c5f9ff"; # bright green (lighter Foam)
    bright3 = "ffeb9e"; # bright yellow (lighter Gold)
    bright4 = "5b9ab7"; # bright blue (lighter Pine)
    bright5 = "eed0ff"; # bright magenta (lighter Iris)
    bright6 = "ffe5e3"; # bright cyan (lighter Rose)
    bright7 = "fefcff"; # bright white (lighter Text)
    flash = "f6c177"; # yellow (Gold)
  };
in {
  options.modules.desktop.foot = with types; {
    enable = mkBoolOpt false "Whether to enable foot terminal emulator.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name}.config = {
      programs.foot = {
        enable = true;
        server.enable = false;
        settings = {
          inherit (themes.rose-pine) colors;
          main = {
            font = "JetBrainsMono Nerd Font:size=12";
            line-height = 14;
            underline-offset = 2;
            pad = "0x0 center";
            term = "xterm-256color";
          };
          scrollback.lines = 2000;
          url.protocols = "http,https,ftp,ftps,file,gemini,gopher,mailto";
          cursor.blink = "yes";
          csd.size = 0;
        };
      };
    };
  };
}
