{
  config,
  lib,
  pkgs,
  username ? "ed",
  ...
}:
with lib; let
  cfg = config.user;
in {
  options.user = with types; {
    name = mkOption {
      type = str;
      default = username;
    };
    fullName = mkOption {
      type = str;
      default = "Ed Roberts Rayne";
    };
    email = mkOption {
      type = str;
      default = "ed.rayne@gmail.com";
    };
    initialHashedPassword = mkOption {
      type = str;
      default = "$y$j9T$vueRmYTLFOtT6Q3jiCH8M/$oTfJQqYfgnDprn/nBxRHgpz90EpDVDtAiV7Aqvx.U95";
    };
    extraGroups = mkOption {
      type = listOf str;
      default = [];
    };
    extraSSHKeys = mkOption {
      type = listOf str;
      default = [];
    };
    shell = mkOption {
      type = package;
      default = pkgs.bash;
    };
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdf/364Rgul97UR6vn4caDuuxBk9fUrRjfpMsa4sfam" # ed@freya
        ];
        inherit (cfg) initialHashedPassword shell;
      };
      users.root = {
        inherit (cfg) initialHashedPassword;
      };
    };
    security.sudo.wheelNeedsPassword = true;
    programs.zsh.enable = true;
  };
}
