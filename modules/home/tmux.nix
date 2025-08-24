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
      shell = "${pkgs.zsh}/bin/zsh";
      extraConfig = ''
        # correct colours in neovim
        set -g default-terminal "screen-256color"
        set -as terminal-features ",xterm-256color:RGB"

        # shift-arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window
      '';

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -agF status-right "#{E:@catppuccin_status_cpu}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_date_time}"
            set -agF status-right "#{E:@catppuccin_status_battery}"
          '';
        }
        {
          plugin = cpu;
        }
        {
          plugin = battery;
        }
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
