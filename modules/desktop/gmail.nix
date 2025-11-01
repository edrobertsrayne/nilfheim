{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.gmail = {
      name = "Gmail";
      comment = "Google Mail";
      exec = "${launch-webapp} \"https://mail.google.com\"";
      icon = ./../../assets/icons/gmail.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, M, Gmail, exec, ${launch-webapp} \"https://mail.google.com\""
    ];
  };
}
