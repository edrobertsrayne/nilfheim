{
  lib,
  osConfig,
  ...
}:
with lib.custom; let
  inherit (osConfig.modules) user;
in {
  config = {
    home = {
      username = "ed";
      stateVersion = "25.05";
    };
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion = enabled;
      };
      starship = enabled;
      git = {
        enable = true;
        userName = user.name;
        userEmail = user.email;
      };
    };
  };
}
