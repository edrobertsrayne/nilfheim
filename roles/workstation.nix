{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.custom) enabled;
in {
  nixpkgs.config.allowUnfree = true;
  modules = {
    hardware.audio = enabled;
    desktop = {
      arduino = enabled;
      gnome = enabled;
      foot = enabled;
      firefox = enabled;
      obsidian = enabled;
      spotify = enabled;
      virtManager = enabled;
      vscode = enabled;
    };
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
