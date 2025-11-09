{inputs, ...}: let
  inherit (inputs.self.niflheim) theme;
in {
  flake.modules.homeManager.theme = {lib, ...}: {
    programs.alacritty.settings.colors = lib.mkForce theme.alacritty.colors;
  };
}
