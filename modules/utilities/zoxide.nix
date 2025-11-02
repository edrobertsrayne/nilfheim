_: {
  flake.modules.generic.utilities = {
    programs.zoxide = {
      enable = true;
    };
    home.shellAliases = {
      ".." = "z ..";
    };
  };
}
