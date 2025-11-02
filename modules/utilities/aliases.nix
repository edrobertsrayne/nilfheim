_: {
  flake.modules.home.utilities = {
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
