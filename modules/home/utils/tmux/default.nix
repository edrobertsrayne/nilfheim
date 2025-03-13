{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.utils.tmux;
in {
  options.${namespace}.utils.tmux = {
    enable = mkEnableOption "Whether to enable tmux.";
  };
  config = mkIf cfg.enable {
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
        {
          plugin = nord;
          extraConfig = ''
                                                            set -g @prefix_highlight_output_prefix "#[fg=#5e81ac]#[bg=default]#[nobold]#[noitalics]#[nounderscore]#[bg=#5e81ac]#[fg=black,bg=default]"
            set -g @prefix_highlight_output_suffix ""
            set -g @prefix_highlight_copy_mode_attr "fg=brightcyan,bg=black,bold"

            set -g status-bg default
            set-option -g status-style bg=default

            set -g status-left "#[fg=brightblack,bg=white]  #S #[fg=white,bg=default,nobold,noitalics,nounderscore]"
            set -g status-right '#[fg=#5e81ac,bg=default,nobold,noitalics,nounderscore]#[fg=white,bg=#5e81ac,nobold,noitalics] #(TZ="America/Los_Angeles" date +%H:%M)  #[fg=white,bg=#5e81ac,nobold,noitalics,nounderscore]#[fg=brightblack,bg=white,nobold] #H  '

            set -g window-status-format "#[fg=#2e3440,bg=black]#[fg=white,bg=black,nobold,noitalics,nounderscore] #I#[fg=white,bg=black,nobold,noitalics,nounderscore]: #W #[fg=black,bg=#2e3440,nobold,noitalics,nounderscore]"
            set -g window-status-current-format "#[fg=#2e3440,bg=#5e81ac]#[fg=white,bg=#5e81ac,nobold,noitalics,nounderscore] #I#[fg=white,bg=#5e81ac,nobold,noitalics,nounderscore]: #W #[fg=#5e81ac,bg=#2e3440,nobold,noitalics,nounderscore]"
            set -g window-status-separator ""

            set -g status-justify left

            set -g pane-active-border-style "bg=black fg=#5e81ac"
          '';
        }
      ];
    };
  };
}
