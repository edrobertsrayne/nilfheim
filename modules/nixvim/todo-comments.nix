_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.todo-comments = {
        enable = true;
        settings = {
          signs = true;
        };
      };
    };
  };
}
