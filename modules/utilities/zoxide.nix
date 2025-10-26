_: {
  flake.modules.homeManager.utilities = {
    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
    home.shellAliases = {
      ".." = "z ..";
    };
  };
}
