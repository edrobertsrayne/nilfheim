_: {
  flake.modules.generic.desktop = {pkgs, ...}: {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };
}
