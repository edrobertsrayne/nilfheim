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
      extraConfig = ''
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        # reload config
        bind r source-file ~/.config/tmux/tmux.conf

        # increase repeat time for repeatable commands
        set -g repeat-time 1000

        set -g detach-on-destroy off
        set -g set-clipboard on

        # Use Alt-arrow keys without prefix key to switch panes
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window
      '';

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
