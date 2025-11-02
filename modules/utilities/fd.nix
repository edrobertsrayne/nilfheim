_: {
  flake.modules.homeManager.utilities = {
    programs.fd = {
      enable = true;
      ignores = [".git/" "*.bak"];
    };
  };
}
