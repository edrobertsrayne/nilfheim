{inputs, ...}: {
  flake.modules.homeManager.utilities = {
    pkgs,
    lib,
    ...
  }: {
    programs.lazydocker.enable = true;

    # Hyprland keybind (launch in terminal)
    wayland.windowManager.hyprland.settings.bindd = let
      launch-terminal = lib.getExe inputs.self.packages.${pkgs.system}.launch-terminal;
    in [
      "SUPER SHIFT, D, LazyDocker, exec, ${launch-terminal} lazydocker"
    ];
  };
}
