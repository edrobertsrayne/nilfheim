{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
  in {
    # Desktop entry
    xdg.desktopEntries.claude = {
      name = "Claude (Web)";
      comment = "AI assistant by Anthropic";
      exec = "${launch-webapp} \"https://claude.ai\"";
      icon = ./../../assets/icons/claude-ai.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };

    # Hyprland keybind
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, A, Open Claude webapp, exec, ${launch-webapp} \"https://claude.ai\""
    ];
  };
}
