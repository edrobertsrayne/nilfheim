{inputs, ...}: let
  inherit (inputs.self.nilfheim) user;
in {
  flake.modules.nixos.user = {
    pkgs,
    lib,
    ...
  }: {
    users.users.${user.username} = {
      isNormalUser = true;
      description = user.fullname;
      extraGroups = ["wheel" "networkmanager"];
      initialPassword = "password";
      packages = with pkgs; [
        vim
        git
        htop
      ];
    };

    security.sudo.wheelNeedsPassword = lib.mkDefault true;
  };

  flake.modules.homeManager.user = {lib, ...}: {
    home = {
      username = lib.mkDefault user.username;
      homeDirectory = lib.mkDefault "/home/${user.username}";
      stateVersion = "25.05";
    };
  };
}
