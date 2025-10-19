{
  lib,
  config,
  pkgs,
  username,
  ...
}:
with lib; {
  imports = [../common/home-manager.nix];

  config = mkIf config.home-manager.enable {
    user.shell = pkgs.zsh;

    home-manager.users.${username} = {
      imports = [
        ../home/common.nix
        ../home/desktop
      ];

      # Platform-specific configuration
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        shell.enableShellIntegration = true;
      };

      programs.git = {
        enable = true;
        userName = config.user.fullName;
        userEmail = config.user.email;
      };
    };
  };
}
