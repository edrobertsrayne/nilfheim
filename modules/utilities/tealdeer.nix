_: {
  flake.modules.home.utilities = {
    programs.tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
      };
    };
  };
}
