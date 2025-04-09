{
  lib,
  osConfig,
  ...
}:
with lib.custom; let
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
      bat = enabled;
      dircolors = enabled;
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
      fzf = enabled;
      git = {
        enable = true;
        userName = user.fullName;
        userEmail = user.email;
      };
      lazygit = enabled;
      nh = enabled;
      password-store = enabled;
      starship = enabled;
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion = enabled;
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
    modules.nvf = enabled;
  };
}
