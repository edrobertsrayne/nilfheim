{inputs, ...}: {
  flake.modules.homeManager.xdg = {lib, ...}: let
    inherit (inputs.self.nilfheim.desktop) browser;

    # Map common browser commands to their .desktop file names
    browserDesktopFile = let
      mapping = {
        firefox = "firefox.desktop";
        chromium = "chromium-browser.desktop";
        brave = "brave-browser.desktop";
        google-chrome = "google-chrome.desktop";
        vivaldi = "vivaldi-stable.desktop";
        opera = "opera.desktop";
        microsoft-edge = "microsoft-edge.desktop";
        epiphany = "org.gnome.Epiphany.desktop";
        qutebrowser = "org.qutebrowser.qutebrowser.desktop";
      };
    in
      mapping.${browser} or "${browser}.desktop";

    # All MIME types that should be handled by the default browser
    browserMimeTypes = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/chrome"
      "text/html"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
    ];
  in {
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = lib.genAttrs browserMimeTypes (_: browserDesktopFile);
      };

      # Custom Alacritty desktop entry with xdg-terminal-exec support
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
