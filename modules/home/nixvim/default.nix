{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixvim;
in {
  options.modules.nixvim = {
    enable = mkEnableOption "Enable neovim (nixvim)";
  };

  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
    ./languages.nix
    ./autocmds.nix
  ];

  config = mkIf cfg.enable {
    # CRITICAL: Disable stylix integration
    stylix.targets.nixvim.enable = false;

    # Dependencies for snacks.nvim (fd and lazygit already in common.nix)
    programs.ripgrep.enable = true;

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      globals = {
        mapleader = " ";
        maplocalleader = "\\";
      };
    };
  };
}
