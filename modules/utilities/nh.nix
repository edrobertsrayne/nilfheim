_: {
  flake.modules.generic.utilities = {
    programs.nh = {
      enable = true;
      flake = "github:edrobertsrayne/nilfheim";
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 3 --keep-since 5d";
      };
    };
  };
}
