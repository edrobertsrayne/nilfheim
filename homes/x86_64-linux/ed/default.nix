{
  lib,
  namespace,
  ...
}:
with lib.${namespace}; {
  asgard = {
    user.enable = true;
    cli = {
      zsh.enable = true;
      git.enable = true;
    };
  };
  programs = {
    bat = enabled;
    btop = enabled;
    eza = enabled;
    fd = enabled;
    fzf = enabled;
    jq = enabled;
    lazygit = enabled;
    lf = enabled;
    password-store = enabled;
    ripgrep = enabled;
    thefuck = enabled;
    tmux = enabled;
    yazi = enabled;
    zoxide = enabled;
  };
}
