{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.custom) enabled;
  inherit (config) user;
in {
  nixpkgs.config.allowUnfree = true;

  catppuccin = {
    flavor = "mocha";
    enable = true;
  };

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

  home-manager = {
    enable = true;
    users.${user.name}.config = {
      catppuccin = {
        flavor = "mocha";
        enable = true;
      };
      programs = {
        alacritty.enable = true;
      };
    };
  };

  modules = {
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
