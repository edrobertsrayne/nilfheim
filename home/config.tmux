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

set -g @prefix_highlight_output_prefix "#[fg=green]#[bg=black]#[nobold]#[noitalics]#[nounderscore]#[bg=green]#[fg=black]"
set -g @prefix_highlight_output_suffix ""
set -g @prefix_highlight_copy_mode_attr "fg=green,bg=black,bold"

set -g status-style bg=black,fg=white
set -g status-left "#[fg=black,bg=blue,bold] #S #[fg=blue,bg=black,nobold,noitalics,nounderscore]"
set -g status-right "#{prefix_highlight}#[fg=blue,bg=black,nobold,noitalics,nounderscore]#[fg=black,bg=blue] %Y-%m-%d #[fg=green,bg=blue,nobold,noitalics,nounderscore]#[fg=black,bg=green] %H:%M #[fg=yellow,bg=green,nobold,noitalics,nounderscore]#[fg=black,bg=yellow,bold] #H "

set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #F #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
set -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#I #[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#W #F #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
set -g window-status-separator ""

