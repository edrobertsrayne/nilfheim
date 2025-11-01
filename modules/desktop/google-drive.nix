{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.google-drive = {
      name = "Google Drive";
      comment = "Google Drive cloud storage";
      exec = "${launch-webapp} \"https://drive.google.com\"";
      icon = ./../../assets/icons/google-drive.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, G, Google Drive, exec, ${launch-webapp} \"https://drive.google.com\""
    ];
  };
}
