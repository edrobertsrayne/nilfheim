_: {
  imports = [./common.nix];

  config = {
    home = {
      username = "ed";
      shell.enableShellIntegration = true;
    };

    catppuccin = {
      flavor = "mocha";
      enable = true;
      wezterm.apply = true;
    };

    programs = {
      alacritty = {
        enable = true;
        settings = {
          font = {
            size = 12.0;
            normal = {
              family = "JetBrainsMono Nerd Font";
              style = "Regular";
            };
          };
          window = {
            opacity = 0.9;
            padding = {
              x = 4;
              y = 0;
            };
            dynamic_padding = true;
          };
          selection.save_to_clipboard = true;
        };
      };
      ghostty.enable = false; # package marked as broken
      wezterm = {
        enable = true;
        extraConfig = ''
            config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
            config.font_size = 12.0
            config.warn_about_missing_glyphs = false

            config.enable_tab_bar = false
            config.window_decorations = "TITLE | RESIZE"
            config.macos_window_background_blur = 30
            config.window_background_opacity = 0.95
            config.window_padding = {
              left = 4,
              right = 4,
              top = 0,
              bottom = 0,
            }
            config.window_close_confirmation = 'NeverPrompt'

            config.max_fps = 120
            config.animation_fps = 60
            config.enable_wayland = false

            config.audible_bell = "Disabled"
            config.scrollback_lines = 10000
            config.enable_scroll_bar = false

            config.keys = {
              {
                key = "f",
                mods = "CTRL",
                action = wezterm.action.ToggleFullScreen,
              },
              {
                key = "'",
                mods = "CTRL",
                action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
              },
              {
                key = "=",
                mods = "CTRL",
                action = wezterm.action.IncreaseFontSize,
              },
              {
                key = "-",
                mods = "CTRL",
                action = wezterm.action.DecreaseFontSize,
              },
              {
                key = "0",
                mods = "CTRL",
                action = wezterm.action.ResetFontSize,
              },
            }

            config.mouse_bindings = {
              {
                event = { Up = { streak = 1, button = "Left" } },
                mods = "CTRL",
                action = wezterm.action.OpenLinkAtMouseCursor,
              },
            }

          return config
        '';
      };
    };
  };
}
