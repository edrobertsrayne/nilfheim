{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.notebooklm = {
      name = "NotebookLM";
      comment = "AI-powered note taking and research assistant";
      exec = "${launch-webapp} \"https://notebooklm.google.com\"";
      icon = ./../../assets/icons/notebooklm.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, N, NotebookLM, exec, ${launch-webapp} \"https://notebooklm.google.com\""
    ];
  };
}
