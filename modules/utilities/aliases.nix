_: {
  flake.modules.homeManager.utilities = {
    home = {
      shell.enableShellIntegration = true;
      shellAliases = {
        c = "clear";
        n = "nvim";
        top = "btop";
        du = "ncdu";
      };
    };
  };
}
