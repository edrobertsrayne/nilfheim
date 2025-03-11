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
  home.shell.enableShellIntegration = true;

  home.stateVersion = "25.05";
}
