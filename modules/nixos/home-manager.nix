{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.home-manager;
in {
  options.modules.home-manager = {
    enable = mkEnableOption "Whether to enable home-manager.";
  };

  config = mkIf cfg.enable {
    modules.user.shell = pkgs.zsh;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.modules.user.name} = import ../home;
      sharedModules = [
        inputs.nvf.homeManagerModules.default
        {
          programs.home-manager = enabled;
          manual = {
            manpages = disabled;
            html = disabled;
            json = disabled;
          };
        }
      ];
    };
  };
}
