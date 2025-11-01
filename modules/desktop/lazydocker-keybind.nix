{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-terminal = lib.getExe inputs.self.packages.${pkgs.system}.launch-terminal;
  in {
    # Hyprland keybind for LazyDocker
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, D, LazyDocker, exec, ${launch-terminal} -e lazydocker"
    ];
  };
}
