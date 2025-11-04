_: {
  flake.modules.homeManager.obsidian = {pkgs, ...}: {
    programs.obsidian = {
      enable = true;
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, O, Obsidian, exec, ${pkgs.obsidian}/bin/obsidian"
    ];
  };
}
