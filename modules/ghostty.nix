{inputs, ...}: {
  flake.modules.homeManager.ghostty = {
    pkgs,
    lib,
    config,
    ...
  }: let
    inherit (config.stylix) fonts opacity;
  in {
    stylix.targets.ghostty.enable = false;
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = [
          fonts.monospace.name
          fonts.emoji.name
        ];
        font-size =
          if pkgs.stdenv.hostPlatform.isDarwin
          then fonts.sizes.terminal * 4.0 / 3.0
          else fonts.sizes.terminal;
        background-opacity = opacity.terminal;
        env = ["TERM=xterm-256color"];
        window-padding-x = 14;
        window-padding-y = 14;
        window-padding-balance = true;
        confirm-close-surface = false;
        resize-overlay = "never";
        gtk-toolbar-style = "flat";
        cursor-style = "block";
        cursor-style-blink = false;
        scrollback-limit = 10000;
        keybind = [
          "shift+insert=paste_from_clipboard"
          "control+insert=copy_to_clipboard"
          "super+control+shift+alt+arrow_down=resize_split:down,100"
          "super+control+shift+alt+arrow_up=resize_split:up,100"
          "super+control+shift+alt+arrow_left=resize_split:left,100"
          "super+control+shift+alt+arrow_right=resize_split:right,100"
        ];
        inherit (inputs.self.niflheim.theme.ghostty) theme;
      };
    };

    xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      terminal-exec = {
        enable = true;
        settings.default = ["ghostty.desktop"];
      };
    };
  };
}
