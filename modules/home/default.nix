{osConfig, ...}: let
  inherit (osConfig) user;
in {
  imports = [
    ./nvf
    ./tmux.nix
  ];

  config = {
    home = {
      username = user.name;
      stateVersion = "25.05";
      shell.enableShellIntegration = true;
    };
    programs = {
      bat.enable = true;
      dircolors.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      eza = {
        enable = true;
        icons = "auto";
        git = true;
      };
      fd = {
        enable = true;
        ignores = [".git/" "*.bak"];
      };
      fzf.enable = true;
      git = {
        enable = true;
        userName = user.fullName;
        userEmail = user.email;
      };
      lazygit.enable = true;
      nh.enable = true;
      password-store.enable = true;
      starship.enable = true;
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        shellAliases = {
          c = "clear";
          ls = "exa";
          l = "ls";
          ".." = "z ..";
          la = "exa -a";
          ll = "exa -al";
          lt = "exa -a --tree --level=2";
          tmux = "tmux -u";
        };
      };
    };
    modules.nvf.enable = true;
  };
}
