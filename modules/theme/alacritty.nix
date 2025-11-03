{inputs, ...}: let
  inherit (inputs.self.nilfheim) theme;
in {
  flake.modules.homeManager.theme = {lib, ...}: {
    programs.alacritty.settings.colors = lib.mkForce theme.alacritty.colors;
  };
}
