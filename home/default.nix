{lib, ...}:
with lib.custom; {
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
    };
  };
}
