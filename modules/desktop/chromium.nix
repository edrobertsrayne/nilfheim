_: {
  flake.modules.home.desktop = {pkgs, ...}: {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };
}
