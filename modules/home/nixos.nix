{osConfig, ...}: let
  inherit (osConfig) user;
in {
  imports = [./common.nix];

  config = {
    home = {
      username = user.name;
      shell.enableShellIntegration = true;
    };

    programs.git = {
      enable = true;
      userName = user.fullName;
      userEmail = user.email;
    };
  };
}
