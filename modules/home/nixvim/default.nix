{
  config,
  lib,
  pkgs,
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
    # Disable stylix to prevent theme conflicts with tokyonight
    stylix.targets.nixvim.enable = false;

    # Dependencies for snacks.nvim (fd and lazygit already in common.nix)
    programs.ripgrep.enable = true;

    # Dependencies for conform.nvim formatters
    home.packages = with pkgs; [
      black # Python formatter
      shfmt # Bash formatter
      stylua # Lua formatter
      nodePackages.prettier # Markdown/YAML/JSON formatter
    ];

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
