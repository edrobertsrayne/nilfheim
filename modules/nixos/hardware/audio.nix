{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.hardware.audio;
in {
  options.hardware.audio = {
    enable = mkEnableOption "Whether to enable pipewire audio support.";
  };
  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
