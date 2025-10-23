{inputs, ...}: let
  inherit (inputs.self.nilfheim) theme;
in {
  flake.modules.nixos.theme = {
  };

  flake.modules.homeManager.theme = {
    imports = [
      inputs.nix-colors.homeManagerModules.default
    ];

    colorScheme = inputs.nix-colors.colorSchemes."${theme.base16}";
  };
}
