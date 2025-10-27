_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      # Terminal tagging
      windowrule = [
        "tag +terminal, class:(Alacritty|kitty|com.mitchellh.ghostty)"

        # Browser tagging
        "tag +chromium-based-browser, class:(Google-chrome|Chromium|Brave-browser|Microsoft-edge|vivaldi|Helium)"
        "tag +firefox-based-browser, class:(firefox|zen-alpha|LibreWolf)"

        # Tiling for chromium browsers (fixes --app flag bug)
        "tile, tag:chromium-based-browser"

        # Browser opacity
        "opacity 1 0.97, tag:chromium-based-browser"
        "opacity 1 0.97, tag:firefox-based-browser"

        # Floating window tag system
        "float, tag:floating-window"
        "center, tag:floating-window"
        "size 800 600, tag:floating-window"

        # Auto-tag floating windows
        "tag +floating-window, class:(blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Nilfheim|About|TUI.float)"
        "tag +floating-window, class:(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), title:^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"

        # Calculator
        "float, class:org.gnome.Calculator"

        # Media applications (no transparency for video quality)
        "opacity 1 1, class:^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
      ];

      windowrulev2 = [
        # Video site opacity exceptions (full opacity for video quality)
        "opacity 1.0 1.0,initialTitle:((?i)(?:[a-z0-9-]+\\.)*youtube\\.com_/|app\\.zoom\\.us_/wc/home)"

        # System utilities
        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(file-roller)$"
        "float,class:^(org.gnome.Nautilus)$"
        "float,class:^(cliphist)$"
        "float,class:^(hyprpolkitagent)$"
        "float,class:^(gcr-prompter)$"
        "float,title:^(Picture-in-Picture)$"
        "pin,title:^(Picture-in-Picture)$"
        "opacity 0.85,class:^(org.gnome.Nautilus)$"
        "opacity 0.95,class:^(pavucontrol)$"
        "opacity 0.95,class:^(blueman-manager)$"
        "size 800 600,class:^(pavucontrol)$"
        "size 700 500,class:^(blueman-manager)$"
      ];

      # Layer rules
      layerrule = [
        "noanim, walker"
      ];
    };
  };
}
