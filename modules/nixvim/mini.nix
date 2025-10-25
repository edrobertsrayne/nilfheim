_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.mini = {
        enable = true;

        modules = {
          ai = {
            n_lines = 500;
          };

          surround = {
          };
        };
      };
    };
  };
}
