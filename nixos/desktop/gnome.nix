{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.desktop.gnome;
  defaultExtensions = with pkgs.gnomeExtensions; [
    gtile
    just-perfection
    logo-menu
    space-bar
    top-bar-organizer
    wireless-hid
  ];
in {
  options.modules.desktop.gnome = with types; {
    enable = mkEnableOption "Whether to enable GNOME desktop environment.";
    color-scheme = mkOpt (enum ["light" "dark"]) "dark" "The colourscheme to use.";
    wayland = mkBoolOpt true "Whether to use Wayland.";
    autoSuspend = mkBoolOpt true "Whether to suspend the machine after inactivity.";
    extensions = mkOpt (listOf package) [] "Extra Gnome extensions to install.";
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
  };
}
