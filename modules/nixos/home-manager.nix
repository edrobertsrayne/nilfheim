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

    home-manager.users.${username} = import ../home/nixos.nix;
  };
}
