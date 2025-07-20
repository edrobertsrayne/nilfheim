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
          "https://cache.saumon.network/proxmox-nixos"
        ];
        trusted-public-keys = [
          "proxmox-nixos:nveXDuVVhFDRFx8Dn19f1WDEaNRJjPrF2CPD2D+m1ys="
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
