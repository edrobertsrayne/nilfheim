_: {
  flake.modules.generic.utilities = {
    programs.fd = {
      enable = true;
      ignores = [".git/" "*.bak"];
    };
  };
}
