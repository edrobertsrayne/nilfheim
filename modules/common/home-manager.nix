{
  lib,
  config,
  inputs,
  pkgs,
  username,
  ...
}:
with lib; let
  cfg = config.home-manager;
in {
  options.home-manager = {
    enable = mkEnableOption "Whether to enable home-manager.";
  };

  config = mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;

      sharedModules = [
        inputs.nvf.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
        {
          programs.home-manager.enable = true;
          manual = {
            manpages.enable = false;
            html.enable = false;
            json.enable = false;
          };
        }
      ];
    };
  };
}
