{
  inputs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.neovim;
in {
  options.modules.neovim = {
    enable = mkEnableOption "Enable neovim";
  };

  imports = [
    ./plugins.nix
    ./keymaps.nix
    ./languages.nix
  ];

  config = mkIf cfg.enable {
    programs.nvf = {
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

          theme = {
            enable = true;
            name = "nord";
            transparent = false;
          };
        };
      };
    };
  };
}
