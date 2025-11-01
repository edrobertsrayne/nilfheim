{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.youtube = {
      name = "YouTube";
      comment = "Watch and share videos";
      exec = "${launch-webapp} \"https://youtube.com\"";
      icon = ./../../assets/icons/youtube.png;
      categories = ["AudioVideo"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, Y, YouTube, exec, ${launch-webapp} \"https://youtube.com\""
    ];
  };
}
