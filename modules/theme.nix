{inputs, ...}: let
  inherit (inputs.self.niflheim) theme user;

  # Base theming configuration shared across all platforms
  base = pkgs: {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.base16}.yaml";
    opacity.terminal = 0.95;
    fonts.monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
  };
in {
  # Theme option definition
  flake.niflheim.theme = inputs.self.lib.themes.tokyonight;

  # NixOS theme module
  flake.modules.nixos.theme = {pkgs, ...}: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix =
      base pkgs
      // {
        # Linux-specific theming
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
    home-manager.users.${user.username}.imports = [inputs.self.modules.homeManager.theme];
  };

  # Darwin theme module
  flake.modules.darwin.theme = {pkgs, ...}: {
    imports = [inputs.stylix.darwinModules.stylix];
    stylix = base pkgs;
    home-manager.users.${user.username}.imports = [inputs.self.modules.homeManager.theme];
  };

  # Home-manager theme module
  flake.modules.homeManager.theme = {lib, ...}: {
    programs.alacritty.settings.colors = lib.mkForce theme.alacritty.colors;
    stylix.targets.nvf.enable = false;
  };
}
