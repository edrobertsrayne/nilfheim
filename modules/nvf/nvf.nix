{inputs, ...}: let
  inherit (inputs.self.nilfheim.theme) nvf;
in {
  flake.modules.homeManager.nvf = {
    imports = [inputs.nvf.homeManagerModules.default];
    stylix.targets.nvf.enable = false;

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;

          theme = {
            enable = true;
            inherit (nvf.theme) name style transparent;
          };
        };
      };
    };
  };
}
