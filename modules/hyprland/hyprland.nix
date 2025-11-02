{inputs, ...}: {
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
  };

  flake.modules.generic.hyprland = let
    inherit (inputs.self.nilfheim.desktop) terminal;
  in {
    wayland.windowManager.hyprland.enable = true;
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      TERMINAL = terminal;
    };
  };
}
