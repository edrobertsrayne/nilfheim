_: {
  flake.modules.generic.zsh = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
    };
  };
}
