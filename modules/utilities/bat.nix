_: {
  flake.modules.generic.utilities = {
    programs.bat.enable = true;
    home.shellAliases = {
      cat = "bat";
    };
  };
}
