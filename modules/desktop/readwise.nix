{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.readwise = {
      name = "Readwise Reader";
      comment = "Read and annotate articles, PDFs, and more";
      exec = "${launch-webapp} \"https://read.readwise.io\"";
      icon = ./../../assets/icons/readwise.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, R, Readwise Reader, exec, ${launch-webapp} \"https://read.readwise.io\""
    ];
  };
}
