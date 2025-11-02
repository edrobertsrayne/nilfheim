_: {
  flake.modules.home.zsh = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
    };
  };
}
