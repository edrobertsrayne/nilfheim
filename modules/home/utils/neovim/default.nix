{
  config,
  namespace,
  lib,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.utils.neovim;
  inherit (lib.strings) hasSuffix fileContents;
  inherit (lib.attrsets) genAttrs;
  inherit (lib.filesystem) listFilesRecursive;
in {
  options.${namespace}.utils.neovim = {
    enable = mkEnableOption "Enable neovim";
  };

  imports = [./plugins.nix ./keymaps.nix ./languages.nix];

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

          luaConfigRC = let
            configPaths = filter (hasSuffix ".lua") (map toString (listFilesRecursive ./lua));
            luaConfig = genAttrs configPaths (file: ''
              ${fileContents file}
            '');
          in
            luaConfig;

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
