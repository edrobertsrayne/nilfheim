{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) fullname email;
in {
  flake.modules.homeManager.core = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        claude-code
      ];
      shell.enableShellIntegration = true;
      shellAliases = {
        c = "clear";
        ls = "eza";
        l = "eza";
        ".." = "z ..";
        la = "eza -a";
        ll = "eza -al";
        lt = "eza -a --tree --level=2";
        cat = "bat";
        top = "btop";
        du = "ncdu";
        diff = "delta";
        prs = "gh pr list";
        issues = "gh issue list";
        n = "nvim";
      };
    };
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
        settings.user = {
          name = "${fullname}";
          inherit email;
          init.defaultBranch = "main";
        };
      };
      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          navigate = true;
          line-numbers = true;
          side-by-side = false;
        };
      };
      jq.enable = true;
      lazydocker.enable = true;
      lazygit.enable = true;
      password-store.enable = true;
      starship.enable = true;
      tealdeer = {
        enable = true;
        settings = {
          updates.auto_update = true;
        };
      };
      tmux.enable = true;
      zellij.enable = true;
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
      };
    };
  };
}
