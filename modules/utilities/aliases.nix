_: {
  flake.modules.homeManager.utilities = {
    home = {
      shell.enableShellIntegration = true;
      shellAliases = {
        c = "clear";
        top = "btop";
        du = "ncdu";
      };
    };
  };
}
