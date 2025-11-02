_: {
  flake.modules.generic.utilities = {
    programs.eza = {
      enable = true;
      icons = "auto";
      git = true;
    };
    home.shellAliases = {
      ls = "eza";
      l = "eza";
      la = "eza -a";
      ll = "eza -al";
      lt = "eza -a --tree --level=2";
    };
  };
}
