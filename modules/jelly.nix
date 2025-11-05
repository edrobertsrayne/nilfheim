{...}: {
  flake.modules.homeManager.jelly = {pkgs, ...}: {
    home.packages = with pkgs; [
      jelly-cli
    ];

    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, J, Jelly (Jellyfin client), exec, uwsm-app -- xdg-terminal-exec jelly"
    ];
  };
}
