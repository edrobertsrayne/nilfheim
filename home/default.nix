{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib.nilfheim; {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = enabled;
    };
    starship = enabled;
  };
}
