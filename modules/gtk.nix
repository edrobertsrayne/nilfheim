_: {
  flake.modules.homeManager.gtk = {pkgs, ...}: {
    gtk = {
      enable = true;
    };
  };
}
