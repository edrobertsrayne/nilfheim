_: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: {
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, ${lib.getExe pkgs.alacritty}"
        "$mod, Q, killactive"
        "$mod, M, exit"
      ];
    };
  };
}
