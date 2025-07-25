{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nvf;
in {
  options.modules.nvf = {
    enable = mkEnableOption "Enable neovim (nvf).";
  };

  imports = [
    ./plugins.nix
    ./keymaps.nix
    ./languages.nix
  ];

  config = mkIf cfg.enable {
    programs = {
      # dependencies for snacks-nvim
      ripgrep.enable = true;
      fd.enable = true;
      lazygit.enable = true;

      nvf = {
        enable = true;
        defaultEditor = true;
        enableManpages = true;
        settings = {
          vim = {
            vimAlias = true;
            viAlias = true;

            withNodeJs = false;
            withPython3 = false;
            withRuby = false;

            clipboard = {
              enable = true;
              providers.wl-copy.enable = true;
              registers = "unnamedplus";
            };

            options = {
              tabstop = 2;
              shiftwidth = 2;
              wrap = false;
            };

            theme = {
              enable = true;
              name = "catppuccin";
              style = "mocha";
            };
          };
        };
      };
    };
  };
}
