{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: {
    wayland.windowManager.hyprland.settings.bindd = let
      launch-menu = lib.getExe inputs.self.packages.${pkgs.system}.launch-menu;
    in [
      "SUPER ALT, SPACE, Launch main menu, exec, ${launch-menu}"
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.launch-menu = pkgs.writeShellApplication {
      name = "launch-menu";
      runtimeInputs = with pkgs; [
        bash
        walker
        alacritty
        hyprpicker
        hyprlock
        systemd
        nh
        procps # provides pgrep/pkill
        inputs.self.packages.${pkgs.system}.launch-presentation-terminal
        inputs.self.packages.${pkgs.system}.take-screenshot
        inputs.self.packages.${pkgs.system}.launch-about
        inputs.self.packages.${pkgs.system}.launch-editor
      ];
      text = builtins.readFile ./launch-menu.sh;
    };
  };
}
