{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli.git;
  inherit (config.${namespace}) user;
in {
  options.${namespace}.cli.git = with types; {
    enable = mkEnableOption "Whether to enable git and github cli tools.";
    userName = mkOption {
      type = str;
      default = user.fullName;
      description = "The name to configure git with.";
    };
    userEmail = mkOption {
      type = str;
      default = user.email;
      description = "The email address to configure git with.";
    };
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      inherit (cfg) userName userEmail;
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    programs.gh = {
      enable = true;
    };
  };
}
