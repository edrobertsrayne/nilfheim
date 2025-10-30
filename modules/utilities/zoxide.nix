_: {
  flake.modules.homeManager.utilities = {
    programs.zoxide = {
      enable = true;
    };
    home.shellAliases = {
      ".." = "z ..";
    };
  };
}
