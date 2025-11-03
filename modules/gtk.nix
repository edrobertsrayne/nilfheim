_: {
  flake.modules.homeManager.gtk = {pkgs, ...}: {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
