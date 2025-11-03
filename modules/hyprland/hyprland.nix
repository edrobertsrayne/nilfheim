{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
  inherit (inputs.self.nilfheim.desktop) terminal;
in {
  flake.modules.nixos.hyprland = {pkgs, ...}: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    imports = with inputs.self.modules.nixos; [
      theme
      desktop
    ];
    home-manager.users.${username}.imports = [
      inputs.self.modules.homeManager.hyprland
    ];
  };

  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.enable = true;
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      TERMINAL = terminal;
    };

    imports = with inputs.self.modules.homeManager; [
      webapps
      xdg
      waybar
      walker
      swayosd
      desktop
      alacritty
      hyprlock
      hypridle
      hyprpaper
      gtk
    ];

    programs = {
      firefox.enable = true;
    };
  };
}
