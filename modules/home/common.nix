{pkgs, ...}: {
  imports = [
    ./desktop.nix
    ./nixvim
    ./tmux.nix
  ];

  config = {
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
      # Data processing
      yq-go

      # Nix utilities
      nix-tree

      # File system tools
      tree
      ncdu
      rsync
    ];

    programs = {
      bat.enable = true;
      btop.enable = true;
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
      gh = {
        enable = true;
        extensions = with pkgs; [gh-markdown-preview];
        settings = {
          git_protocol = "ssh";
          editor = "nvim";
          prompt = "enabled";
        };
      };
      git = {
        enable = true;
        userName = "Ed Roberts Rayne";
        userEmail = "ed.rayne@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
        };
        delta = {
          enable = true;
          options = {
            navigate = true;
            line-numbers = true;
            side-by-side = false;
          };
        };
      };
      jq.enable = true;
      lazygit.enable = true;
      nh.enable = true;
      password-store.enable = true;
      starship.enable = true;
      tealdeer = {
        enable = true;
        settings = {
          updates.auto_update = true;
        };
      };
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
          cat = "bat";
          top = "btop";
          du = "ncdu";
          diff = "delta";
          prs = "gh pr list";
          issues = "gh issue list";
        };
        initExtra = ''
          # Smart nvim launcher - open current dir if no args, otherwise open specified files
          n() {
            if [ "$#" -eq 0 ]; then
              nvim .
            else
              nvim "$@"
            fi
          }
        '';
      };
    };

    modules.nixvim.enable = true;
  };
}
