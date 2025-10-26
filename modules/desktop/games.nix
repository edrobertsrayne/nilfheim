_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      mangohud
      protonup-ng
      bottles
      heroic
      moonlight-qt
      steam
    ];
    programs.lutris.enable = true;
  };
}
