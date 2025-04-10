{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  wallpaper = "/home/ed/Pictures/Wallpapers/among-trees-campsite.jpg";
  cfg = config.desktop.gnome;
  inherit (config) desktop user;
  defaultExtensions = with pkgs.gnomeExtensions; [
    caffeine
    just-perfection
    removable-drive-menu
    space-bar
    tactile
  ];
in {
  options.desktop.gnome = with types; {
    enable = mkEnableOption "Whether to enable the Gnome desktop environment.";
    extraExtensions = mkOpt (listOf package) [] "Extra Gnome extensions to install.";
    darkMode = mkBoolOpt true "Whether to prefer dark mode.";
  };

  config = mkIf cfg.enable {
    desktop = {
      xkb.enable = true;
      gtk.enable = true;
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany
      geary
      gnome-maps
      gnome-photos
      cheese
      gnome-music
      gedit
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      gnome-initial-setup
      gnome-contacts
      gnome-font-viewer
    ];

    environment.systemPackages = with pkgs;
      [
        gnome-tweaks
        wl-clipboard
      ]
      ++ defaultExtensions
      ++ cfg.extraExtensions;

    services = {
      libinput.enable = true;
      xserver = {
        enable = true;
        displayManager = {
          gdm = {
            enable = true;
            wayland = true;
            autoSuspend = true;
          };
        };
        desktopManager.gnome.enable = true;
      };
    };

    programs.dconf.enable = true;
    home-manager.users.${user.name} = {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme =
            if cfg.darkMode
            then "prefer-dark"
            else "default";
          enable-hot-corners = false;
        };
        "org/gnome/desktop/background" = {
          picture-options = "zoom";
          picture-uri = "file://${wallpaper}";
          picture-uri-dark = "file://${wallpaper}";
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${wallpaper}";
        };
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions =
            [
              "native-window-placement@gnome-shell-extensions.gcampax.github.com"
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
            ]
            ++ builtins.map (extension: "${extension.extensionUuid}") (defaultExtensions ++ cfg.extraExtensions);

          favorite-apps =
            [
              "org.gnome.Nautilus.desktop"
            ]
            ++ optional desktop.firefox.enable "firefox.desktop"
            ++ optional desktop.foot.enable "foot.desktop"
            ++ optional desktop.vscode.enable "code.desktop"
            ++ optional desktop.obsidian.enable "obsidian.desktop"
            ++ optional desktop.arduino.enable "arduino-ide.desktop"
            ++ optional desktop.spotify.enable "spotify.desktop"
            ++ optional config.programs.steam.enable "steam.desktop";
        };
        "org/gnome/desktop/peripherals/mouse" = {
          speed = 0.0;
          accel-profile = "flat";
          natural-scroll = true;
        };
        "org/gnome/desktop/peripherals/touchpad" = {
          disable-while-typing = false;
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-8 = ["<Super>8"];
          switch-to-workspace-9 = ["<Super>9"];
          switch-to-workspace-10 = ["<Super>0"];

          move-to-workspace-1 = ["<Shift><Super>1"];
          move-to-workspace-2 = ["<Shift><Super>2"];
          move-to-workspace-3 = ["<Shift><Super>3"];
          move-to-workspace-4 = ["<Shift><Super>4"];
          move-to-workspace-5 = ["<Shift><Super>5"];
          move-to-workspace-6 = ["<Shift><Super>6"];
          move-to-workspace-7 = ["<Shift><Super>7"];
          move-to-workspace-8 = ["<Shift><Super>8"];
          move-to-workspace-9 = ["<Shift><Super>9"];
          move-to-workspace-10 = ["<Shift><Super>0"];
        };
        "org/gnome/shell/keybindings" = {
          # Remove the default hotkeys for opening favorited applications.
          switch-to-application-1 = [];
          switch-to-application-2 = [];
          switch-to-application-3 = [];
          switch-to-application-4 = [];
          switch-to-application-5 = [];
          switch-to-application-6 = [];
          switch-to-application-7 = [];
          switch-to-application-8 = [];
          switch-to-application-9 = [];
          switch-to-application-10 = [];
        };
        "org/gnome/tweaks" = {
          show-extensions-notice = false;
        };
        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 5;
        };
        "org/gnome/mutter" = {
          dynamic-workspaces = false;
        };
        "org/gnome/shell/extensions/just-perfection" = {
          support-notifier-type = 0;
          window-maximized-on-create = false;
          animation = 2;
        };
        "org/gnome/shell/extensions/tactile" = {
          col-0 = 2;
          col-3 = 2;
        };
      };
    };
  };
}
