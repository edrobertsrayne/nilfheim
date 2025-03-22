{
  config,
  lib,
  pkgs,
  username ? "ed",
  ...
}:
with lib; let
  inherit (lib.custom) mkOpt enabled;
  cfg = config.modules.user;
in {
  options.modules.user = with types; {
    name = mkOpt str username "The main to use for the user account.";
    fullName = mkOpt str "Ed Roberts Rayne" "The user's full name.";
    email = mkOpt str "ed.rayne@gmail.com" "The user's email address.";
    initialHashedPassword = mkOption {
      type = str;
      default = "$y$j9T$vueRmYTLFOtT6Q3jiCH8M/$oTfJQqYfgnDprn/nBxRHgpz90EpDVDtAiV7Aqvx.U95";
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0EYKmro8pZDXNyT5NiBZnRGhQ/5HlTn5PJEWRawUN1"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjO/+Q0fcuPJlilQNFfTbxG78ov3owvJW66poCTZVy4"
        ];
        shell = pkgs.zsh;
        inherit (cfg) initialHashedPassword;
      };
    };
    security.sudo.wheelNeedsPassword = false;
    programs.zsh = enabled;
  };
}
