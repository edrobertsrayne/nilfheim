_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.flash = {
      enable = true;
      settings = {
        modes.char.keys = {
          f = "f";
          F = "F";
          t = "t";
          T = "T";
        };
      };
    };
  };
}
