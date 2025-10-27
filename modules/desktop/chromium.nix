_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };
}
