{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.nix;
in {
  options.system.nix = {
    enable = mkEnableOption "Whether to enable nix settings.";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
        warn-dirty = false;
        trusted-users = ["root" config.user.name];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        extra-substituters = ["https://walker.cachix.org" "https://walker-git.cachix.org"];
        extra-trusted-public-keys = ["walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
    system.autoUpgrade = {
      enable = true;
      flake = "github:edrobertsrayne/nilfheim";
      flags = [];
      dates = "04:00";
    };
  };
}
