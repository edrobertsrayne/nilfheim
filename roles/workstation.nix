{
  config,
  pkgs,
  lib,
  ...
}:
with lib.custom; {
  nixpkgs.config.allowUnfree = true;
  stylix = {
    enable = true;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };
  modules = {
    hardware.audio = enabled;
    desktop = {
      arduino = enabled;
      gnome = enabled;
      foot = enabled;
      firefox = enabled;
      obsidian = enabled;
      spotify = enabled;
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
