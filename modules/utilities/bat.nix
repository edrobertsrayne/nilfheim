_: {
  flake.modules.home.utilities = {
    programs.bat.enable = true;
    home.shellAliases = {
      cat = "bat";
    };
  };
}
