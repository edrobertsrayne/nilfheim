{
  pkgs,
  config,
  namespace,
  lib,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli.zsh;
in {
  options.${namespace}.cli.zsh = {
    enable = mkEnableOption "Whether to enable zsh.";
  };
  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
      };
      starship.enable = true;
    };
    home.shell.enableShellIntegration = true;
  };
}
