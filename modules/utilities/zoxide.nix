_: {
  flake.modules.home.utilities = {
    programs.zoxide = {
      enable = true;
    };
    home.shellAliases = {
      ".." = "z ..";
    };
  };
}
