{inputs, ...}: let
  inherit (inputs.self.nilfheim) theme;
in {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.base16}.yaml";
    };
  };
}
