{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nilfheim.user;
in {
  options.nilfheim.user = with types; {
    name = mkOpt str "ed" "The main to use for the user account.";
    fullName = mkOpt str "Ed Roberts Rayne" "The user's full name.";
    email = mkOpt str "ed.rayne@gmail.com" "The user's email address.";
    initialHashedPassword = mkOption {
      type = str;
      default = "$y$j9T$JYQ3.uYakfzCK9H9v76dr.$LZWvasy4PvMfupxMdHrN7tnC.hfzPJEholafgekBK82";
      description = "The hashed password to use when the user is first created.";
    };
    extraGroups = mkOpt (listOf str) [] "Groups to assign the user to.";
    extraSSHKeys = mkOpt (listOf str) [] "Additional authorised SSH keys.";
  };
  config = {
    users = {
      mutableUsers = false;
      users.${cfg.name} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0EYKmro8pZDXNyT5NiBZnRGhQ/5HlTn5PJEWRawUN1 ed@imac"
        ];
        shell = pkgs.zsh;
      };
    };
  };
}
