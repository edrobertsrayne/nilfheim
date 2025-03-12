{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = with types; {
    name = mkOption {
      type = str;
      default = "ed";
      description = "The name to use for the user account.";
    };
    fullName = mkOption {
      type = str;
      default = "Ed Roberts Rayne";
      description = "The full name of the user.";
    };
    email = mkOption {
      type = str;
      default = "ed.rayne@gmail.com";
      description = "The email of the user.";
    };
    initialHashedPassword = mkOption {
      type = str;
      default = "$y$j9T$JYQ3.uYakfzCK9H9v76dr.$LZWvasy4PvMfupxMdHrN7tnC.hfzPJEholafgekBK82";
      description = "The initial hashed password to use when the user is first created.";
    };
    extraGroups = mkOption {
      type = listOf str;
      default = [];
      description = "Groups for the user to be assigned.";
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
    };

    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name initialHashedPassword;
      extraGroups = ["wheel" "networkmanager"] ++ cfg.extraGroups;
      shell = pkgs.zsh;
    };
  };
}
