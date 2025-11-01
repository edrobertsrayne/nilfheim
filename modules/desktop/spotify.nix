_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    # Install Spotify
    home.packages = [pkgs.spotify];

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, S, Spotify, exec, ${pkgs.spotify}/bin/spotify"
    ];
  };
}
