{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.p5js = {
      name = "p5.js Editor";
      comment = "Creative coding web editor";
      exec = "${launch-webapp} \"https://editor.p5js.org\"";
      icon = ./../../assets/icons/p5js.png;
      categories = ["Development"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, P, p5.js Editor, exec, ${launch-webapp} \"https://editor.p5js.org\""
    ];
  };
}
