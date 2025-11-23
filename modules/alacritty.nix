_: {
  flake.modules.homeManager.alacritty = {
    pkgs,
    lib,
    ...
  }: {
    programs.alacritty = {
      enable = true;
      settings = {
        env = {TERM = "xterm-256color";};
        window = {
          padding = {
            x = 14;
            y = 14;
          };
          decorations = "None";
        };
        keyboard.bindings = [
          {
            key = "Insert";
            mods = "Shift";
            action = "Paste";
          }
          {
            key = "Insert";
            mods = "Control";
            action = "Copy";
          }
        ];
      };
    };
    xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      dataFile."applications/alacritty-custom.desktop".text = ''
        [Desktop Entry]
        Type=Application
        TryExec=alacritty
        Exec=alacritty
        Icon=Alacritty
        Terminal=false
        Categories=System;TerminalEmulator;
        Name=Alacritty
        GenericName=Terminal
        Comment=A fast, cross-platform, OpenGL terminal emulator
        StartupNotify=true
        StartupWMClass=Alacritty
        Actions=New;
        X-TerminalArgExec=-e
        X-TerminalArgAppId=--class=
        X-TerminalArgTitle=--title=
        X-TerminalArgDir=--working-directory=

        [Desktop Action New]
        Name=New Terminal
        Exec=alacritty
      '';

      terminal-exec = {
        enable = true;
        settings.default = ["alacritty-custom.desktop"];
      };
    };
  };
}
