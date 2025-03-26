{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.custom) enabled;
in {
  nixpkgs.config.allowUnfree = true;
  desktop = {
    gnome = enabled;
    arduino = enabled;
    foot = enabled;
    firefox = enabled;
    obsidian = enabled;
    spotify = enabled;
    virtManager = enabled;
    vscode = enabled;
  };
  modules = {
    home-manager = enabled;
    hardware.audio = enabled;
    system = {
      fonts = enabled;
      xkb = enabled;
    };
  };
  environment.systemPackages = with pkgs; [
    processing
    vlc
  ];
}
