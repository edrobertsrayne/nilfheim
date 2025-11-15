_: {
  flake.modules.homeManager.wezterm = _: {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local wezterm = require('wezterm')
        local config = wezterm.config_builder()

        -- Window & UI: Clean minimal appearance
        config.enable_tab_bar = false
        config.window_decorations = "RESIZE"
        config.window_close_confirmation = "NeverPrompt"
        config.automatically_reload_config = true

        -- Window Padding: Match Alacritty style
        config.window_padding = {
          left = 14,
          right = 14,
          top = 14,
          bottom = 14,
        }

        -- macOS-Specific Polish
        config.native_macos_fullscreen_mode = true
        config.use_ime = true
        config.send_composed_key_when_left_alt_is_pressed = false
        config.send_composed_key_when_right_alt_is_pressed = true

        -- Performance Optimization
        config.front_end = "WebGpu"
        config.max_fps = 120

        -- Keybindings
        config.keys = {
          -- CMD+, to open config (macOS standard)
          {
            key = ',',
            mods = 'CMD',
            action = wezterm.action.SpawnCommandInNewTab {
              args = { os.getenv('SHELL'), '-c', '$EDITOR $HOME/Projects/niflheim/' },
            },
          },
          -- CMD+arrow for pane navigation
          {
            key = 'LeftArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection('Left'),
          },
          {
            key = 'RightArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection('Right'),
          },
          {
            key = 'UpArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection('Up'),
          },
          {
            key = 'DownArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection('Down'),
          },
        }

        return config
      '';
    };
  };
}
