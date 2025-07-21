{username, ...}: {
  imports = [../common/home-manager.nix];

  config = {
    home-manager = {
      enable = true;
      users.${username} = import ../home/darwin.nix;
    };
  };
}
