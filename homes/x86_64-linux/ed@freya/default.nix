{...}: {
  programs.git = {
    enable = true;
    userEmail = "ed.rayne@gmail.com";
    userName = "Ed Roberts Rayne";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.username = "ed";

  home.shell.enableShellIntegration = true;

  home.stateVersion = "25.05";
}
