_: {
  flake.modules.homeManager.desktop = {
    services.swayosd = {
      enable = true;
    };
  };
}
