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
      git = {
        enable = true;
        userName = "Ed Roberts Rayne";
        userEmail = "ed.rayne@gmail.com";
      };
      wezterm = {
        enable = true;
        extraConfig = ''
          local mylib = require 'mylib'
          return {
                  enable_wayland = false,
                  enable_tab_bar = false,
                  font_size = 12.0,
                  font = wezterm.font("JetBrainsMono Nerd Font"),
                  macos_window_background_blur = 30,
                  window_background_opacity = 0.95,
                  window_decorations = "TITLE | RESIZE",
                  warn_about_missing_glyphs = false,
                  keys = {
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
                  },
                  mouse_bindings = {
                          {
                                  event = { Up = { streak = 1, button = "Left" } },
                                  mods = "CTRL",
                                  action = wezterm.action.OpenLinkAtMouseCursor,
                          },
                  },
          }
        '';
      };
    };
  };
}
