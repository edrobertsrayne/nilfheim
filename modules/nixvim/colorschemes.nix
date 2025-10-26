_: {
  flake.modules.homeManager.nixvim = {
    stylix.targets.nixvim.enable = false;
    programs.nixvim.colorschemes = {
      tokyonight = {
        enable = true;
        settings = {
          style = "night";
          transparent = true;
        };
      };
    };
  };
}
