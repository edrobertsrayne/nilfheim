{
  config,
  namespace,
  lib,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.shell.zsh;
in {
  options.${namespace}.shell.zsh = {
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
    home.shell.enableZshIntegration = true;
  };
}
