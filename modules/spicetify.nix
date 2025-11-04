{inputs, ...}: {
  flake.modules.homeManager.spicetify = {pkgs, ...}: {
    imports = [inputs.spicetify-nix.homeManagerModules.spicetify];
    programs.spicetify.enable = true;
    wayland.windowManager.hyprland.settings = {
      bindd = [
        "SUPER SHIFT, S, Spotify, exec, ${pkgs.spotify}/bin/spotify"
      ];
      windowrule = [
        "workspace name:spotify, class:spotify"
      ];
    };
  };
}
