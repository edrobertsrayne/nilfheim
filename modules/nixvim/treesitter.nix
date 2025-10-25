_: {
  flake.modules.homeManager.nixvim = {pkgs, ...}: {
    programs.nixvim.plugins = {
      treesitter = {
        enable = true;
	autoLoad = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        folding = true;
      };
    };
  };
}
