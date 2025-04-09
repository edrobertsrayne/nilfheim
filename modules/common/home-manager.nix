{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.home-manager;
in {
  options.home-manager = {
    enable = mkEnableOption "Whether to enable home-manager.";
  };

  config = mkIf cfg.enable {
    user.shell = pkgs.zsh;
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;

      sharedModules = [
        inputs.nvf.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
        {
          programs.home-manager = enabled;
          manual = {
            manpages = disabled;
            html = disabled;
            json = disabled;
          };
        }
      ];

      users.${config.user.name} = import ../home;
    };
  };
}
