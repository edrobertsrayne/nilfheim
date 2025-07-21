_: {
  imports = [./common.nix];

  config = {
    home = {
      username = "ed";
      shell.enableShellIntegration = true;
    };

    programs = {
      alacritty.enable = true;
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
