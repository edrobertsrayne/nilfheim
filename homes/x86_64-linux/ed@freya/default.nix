{...}: {
  programs.git = {
    enable = true;
    userEmail = "ed.rayne@gmail.com";
    userName = "Ed Roberts Rayne";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
  };

  home.username = "ed";

  home.shell.enableShellIntegration = true;

  home.stateVersion = "25.05";
}
