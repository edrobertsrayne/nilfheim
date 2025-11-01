{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.google-calendar = {
      name = "Google Calendar";
      comment = "Google Calendar";
      exec = "${launch-webapp} \"https://calendar.google.com\"";
      icon = ./../../assets/icons/google-calendar.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, C, Google Calendar, exec, ${launch-webapp} \"https://calendar.google.com\""
    ];
  };
}
