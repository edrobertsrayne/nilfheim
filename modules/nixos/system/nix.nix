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
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
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
