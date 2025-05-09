{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
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
