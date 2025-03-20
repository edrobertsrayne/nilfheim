{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.desktop.gnome;
  inherit (config.modules) user desktop;
  defaultExtensions = with pkgs.gnomeExtensions; [
    caffeine
    clipboard-indicator
    just-perfection
    removable-drive-menu
    space-bar
    tactile
    vitals
  ];
in {
  options.modules.desktop.gnome = with types; {
    enable = mkEnableOption "Whether to enable GNOME desktop environment.";
    wayland = mkBoolOpt true "Whether to use Wayland.";
    autoSuspend = mkBoolOpt true "Whether to suspend the machine after inactivity.";
    extensions = mkOpt (listOf package) [] "Extra Gnome extensions to install.";
    darkMode = mkBoolOpt true "Whether to prefer dark mode.";
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.gtk = enabled;
      system.xkb = enabled;
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
      ++ cfg.extensions;

    services = {
      libinput.enable = true;
      xserver = {
        enable = true;
        displayManager = {
          gdm = {
            enable = true;
            inherit (cfg) wayland autoSuspend;
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
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions =
            [
              "native-window-placement@gnome-shell-extensions.gcampax.github.com"
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
            ]
            ++ builtins.map (extension: "${extension.extensionUuid}") defaultExtensions;
          favorite-apps =
            [
              "org.gnome.Nautilus.desktop"
            ]
            ++ optional desktop.firefox.enable "firefox.desktop"
            ++ optional desktop.foot.enable "foot.desktop"
            ++ optional desktop.vscode.enable "code.desktop"
            ++ optional desktop.obsidian.enable "obsidian.desktop"
            ++ optional desktop.arduino.enable "arduino-ide.desktop"
            ++ optional desktop.spotify.enable "spotify.desktop";
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
          window-maximized-on-create = true;
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
