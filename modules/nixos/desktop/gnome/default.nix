{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.gnome;
  inherit (config.${namespace}) user;
  defaultExtensions = with pkgs.gnomeExtensions; [
    gtile
    just-perfection
    logo-menu
    space-bar
    top-bar-organizer
    wireless-hid
  ];
in {
  options.${namespace}.desktop.gnome = with types; {
    enable = mkEnableOption "Whether to enable the GNOME desktop environment.";
    color-scheme = mkOpt (enum ["light" "dark"]) "dark" "The colourscheme to use.";
    wayland = mkBoolOpt true "Whether to use Wayland.";
    autoSuspend = mkBoolOpt true "Whether to suspend the machine after inactivity.";
    extensions = mkOpt (listOf package) [] "Extra Gnome extensions to install.";
  };
  config = mkIf cfg.enable {
    ${namespace} = {
      system.xkb = enabled;
      desktop.addons = {
        gtk = enabled;
      };
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
      gnome-system-monitor
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
    snowfallorg.users.${user.name}.home.config = {
      dconf.settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          favorite-apps = ["org.gnome.Nautilus.desktop" "firefox.desktop"];
        };

        "org/gnome/desktop/peripherals/mouse" = {
          speed = 0.0;
          accel-profile = "flat";
          natural-scroll = true;
        };
        "org/gnome/desktop/peripherals/touchpad" = {
          disable-while-typing = false;
        };
        "org/gnome/desktop/peripherals/keyboard" = {
          delay = lib.home-manager.hm.gvariant.mkUint32 200;
        };
        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 10;
          resize-with-right-button = true;
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
          # Remove the default hotkeys for opening applications.
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
      };
    };
  };
}
