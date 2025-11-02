_: {
  flake.modules.generic.utilities = {
    programs.tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
      };
    };
  };
}
