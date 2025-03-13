{
  lib,
  namespace,
  ...
}:
with lib.${namespace}; {
  asgard = {
    user = enabled;
    shell.zsh = enabled;
    utils = {
      tmux = enabled;
      git = enabled;
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
    yazi = enabled;
    zoxide = enabled;
  };
}
