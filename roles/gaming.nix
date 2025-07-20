{
  lib,
  pkgs,
  ...
}:
with lib; {
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
