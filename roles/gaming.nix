{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
  ];
}
