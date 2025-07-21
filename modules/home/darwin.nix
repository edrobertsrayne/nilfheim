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
      wezterm.enable = true;
    };
  };
}
