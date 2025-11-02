{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: {
    wayland.windowManager.hyprland.settings.bindd = let
      launch-menu = lib.getExe inputs.self.packages.${pkgs.system}.launch-menu;
    in [
      "SUPER SHIFT, SPACE, Main menu, exec, ${launch-menu}"
    ];
  };

  perSystem = {pkgs, ...}: let
    selfPkgs = inputs.self.packages.${pkgs.system};
  in {
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
        selfPkgs.launch-presentation-terminal
        selfPkgs.take-screenshot
        selfPkgs.launch-about
        selfPkgs.launch-webapp
        selfPkgs.launch-editor
        selfPkgs.show-keybindings
      ];
      text = builtins.readFile ./launch-menu.sh;
    };

    packages.show-keybindings = pkgs.writeShellApplication {
      name = "show-keybindings";
      runtimeInputs = with pkgs; [
        hyprland
        jq
        walker
        libxkbcommon
        gawk
        gnused
        coreutils
      ];
      text = builtins.readFile ./show-keybindings.sh;
    };
  };
}
