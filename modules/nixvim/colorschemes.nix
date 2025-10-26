{inputs, ...}: let
  inherit (inputs.self.nilfheim) theme;
in {
  flake.modules.homeManager.nixvim = {
    stylix.targets.nixvim.enable = false;
    programs.nixvim = {
      inherit (theme) colorschemes;
    };
  };
}
