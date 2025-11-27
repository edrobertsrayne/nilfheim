{inputs, ...}: let
  inherit (inputs.self.niflheim) user;

  base = pkgs: {
    enable = true;
    base16Scheme = pkgs.lib.mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";
    opacity.terminal = 0.75;
    fonts.monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
  };
in {
  flake = {
    modules = {
      nixos.stylix = {pkgs, ...}: {
        imports = [inputs.stylix.nixosModules.stylix];

        stylix =
          base pkgs
          // {
            icons = {
              enable = true;
              package = pkgs.papirus-icon-theme;
              dark = "Papirus-Dark";
            };
            cursor = {
              package = pkgs.bibata-cursors;
              name = "Bibata-Modern-Classic";
              size = 24;
            };
            targets.grub.enable = false;
          };
        home-manager.users.${user.username}.imports = [inputs.self.modules.homeManager.stylix];
      };

      darwin.stylix = {pkgs, ...}: {
        imports = [inputs.stylix.darwinModules.stylix];
        stylix = base pkgs;
        home-manager.users.${user.username}.imports = [inputs.self.modules.homeManager.stylix];
      };

      homeManager.stylix = {};
    };
  };
}
