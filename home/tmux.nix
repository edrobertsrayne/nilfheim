{pkgs, ...}: {
  config = {
    programs.tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      escapeTime = 1;
      historyLimit = 5000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-s";
      sensibleOnTop = true;
      extraConfig = builtins.readFile ./config.tmux;

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '30'
          '';
        }
        resurrect
        {
          plugin = tmux-fzf;
          extraConfig = ''
            TMUX_FZF_LAUNCH_KEY="C-f"
          '';
        }
        vim-tmux-navigator
        sensible
        yank
        {
          plugin = tilish;
          extraConfig = ''
            set -g @tilish-navigator "on"
            set -g @tilish-default "main-vertical"
            bind-key -n "M-q" kill-pane
          '';
        }
      ];
    };
  };
}
