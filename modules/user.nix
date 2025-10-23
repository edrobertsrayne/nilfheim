_: let
  username = "ed";
  fullname = "Ed Roberts Rayne";
in {
  flake.modules.nixos.user = {
    pkgs,
    lib,
    ...
  }: {
    users.users.${username} = {
      isNormalUser = true;
      description = fullname;
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
      username = lib.mkDefault username;
      homeDirectory = lib.mkDefault "/home/${username}";
      stateVersion = "25.05";
    };
  };
}
