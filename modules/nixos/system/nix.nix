{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.modules.system.nix;
in {
  options.modules.system.nix = {
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
  };
}
