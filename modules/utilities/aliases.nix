_: {
  flake.modules.generic.utilities = {
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
