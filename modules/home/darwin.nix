{
  config,
  lib,
  ...
}: {
  imports = [./common.nix];

  config = {
    home = {
      username = "ed";
      shell.enableShellIntegration = true;
    };

    programs.git = {
      enable = true;
      userName = "Ed Roberts Rayne";
      userEmail = "ed.rayne@gmail.com";
    };
  };
}
