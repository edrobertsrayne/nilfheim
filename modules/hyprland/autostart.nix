{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    monitor-event-handler = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.monitor-event-handler;
  in {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "hyprpolkitagent"
        "waypaper --restore"
        monitor-event-handler
      ];
    };
  };
}
