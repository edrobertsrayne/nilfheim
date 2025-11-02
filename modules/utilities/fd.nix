_: {
  flake.modules.home.utilities = {
    programs.fd = {
      enable = true;
      ignores = [".git/" "*.bak"];
    };
  };
}
