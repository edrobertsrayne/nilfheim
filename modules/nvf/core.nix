{inputs, ...}: let
  inherit (inputs.self.nilfheim.theme) nvf;
in {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          # ===== CORE SETTINGS =====
          # Enable vi/vim command aliases for compatibility
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
