{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = {
    enable = mkEnableOption "Whether to configure the user account";
    name = mkOption {
      type = types.str;
      default = "ed";
      description = "The user account name.";
    };
    fullName = mkOption {
      type = types.str;
      default = "Ed Roberts Rayne";
      description = "The full name of the user.";
    };
    email = mkOption {
      type = types.str;
      default = "ed.rayne@gmail.com";
      description = "The email address of the user.";
    };
  };
  config = mkIf cfg.enable {
    home.username = mkDefault cfg.name;
  };
}
