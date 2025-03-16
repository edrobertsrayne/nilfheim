{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.desktop.foot;
  inherit (config.modules) user;
  themes.nord.colors = {
    foreground = "d8dee9";
    background = "2e3440";

    regular0 = "3b4252";
    regular1 = "bf616a";
    regular2 = "a3be8c";
    regular3 = "ebcb8b";
    regular4 = "81a1c1";
    regular5 = "b48ead";
    regular6 = "88c0d0";
    regular7 = "e5e9f0";

    bright0 = "4c566a";
    bright1 = "bf616a";
    bright2 = "a3be8c";
    bright3 = "ebcb8b";
    bright4 = "81a1c1";
    bright5 = "b48ead";
    bright6 = "8fbcbb";
    bright7 = "eceff4";

    dim0 = "373e4d";
    dim1 = "94545d";
    dim2 = "809575";
    dim3 = "b29e75";
    dim4 = "68809a";
    dim5 = "8c738c";
    dim6 = "6d96a5";
    dim7 = "aeb3bb";
  };
in {
  options.modules.desktop.foot = with types; {
    enable = mkBoolOpt false "Whether to enable foot terminal emulator.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name}.config = {
      programs.foot = {
        enable = true;
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
          cursor.blink = "yes";
          inherit (themes.nord) colors;
        };
      };
    };
  };
}
