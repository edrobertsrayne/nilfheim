_: {
  flake.modules.homeManager.utilities = {
    programs.bat.enable = true;
    home.shellAliases = {
      cat = "bat";
    };
  };
}
