{...}: {
  imports = [
    ./nvf
    ./tmux.nix
  ];

  config = {
    home.stateVersion = "25.05";

    programs = {
      bat.enable = true;
      dircolors.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
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
        userName = "Ed Roberts Rayne";
        userEmail = "ed.rayne@gmail.com";
        extraConfig = {init.defaultBranch = "main";};
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
          ls = "eza";
          l = "eza";
          ".." = "z ..";
          la = "eza -a";
          ll = "eza -al";
          lt = "eza -a --tree --level=2";
          tmux = "tmux -u";
        };
      };
    };

    modules.nvf.enable = true;
  };
}
