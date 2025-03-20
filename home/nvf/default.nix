{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
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
            name = "rose-pine";
            style = "main";
          };

          luaConfigRC.general = builtins.readFile ./lua/general.lua;
        };
      };
    };
  };
}
