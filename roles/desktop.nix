{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.custom) enabled;
  inherit (config.modules) user;
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

  home-manager.users.${user.name}.config = {
    catppuccin = {
      flavor = "mocha";
      enable = true;
    };
    programs = {
      alacritty.enable = true;
    };
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
