_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.tmux-navigator.enable = true;
  };
}
