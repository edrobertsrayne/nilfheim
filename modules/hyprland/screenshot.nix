{inputs, ...}: let
  app = pkgs:
    pkgs.writeShellApplication {
      name = "take-screenshot";
      runtimeInputs = with pkgs; [
        grimblast
        satty
        wl-clipboard
        libnotify
      ];
      text = ''
        OUTPUT_DIR="$HOME/Pictures/Screenshots/"

        if [[ ! -d  "$OUTPUT_DIR" ]]; then
          notify-send "Screenshot directory does not exist" -u critical -t 3000
          exit 1
        fi

        MODE="''${1:-output}"

        grimblast --freeze save "$MODE" - | satty --filename - \
          --output-filename "$OUTPUT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png" \
          --early-exit \
          --actions-on-enter save-to-clipboard \
          --save-after-copy \
          --copy-command 'wl-copy'
      '';
    };
in {
  flake.modules.homeManager.hyprland = {
    lib,
    pkgs,
    ...
  }: {
    home = {
      packages = with pkgs; [
        hyprpicker
      ];

      # Ensure Screenshots directory exists
      activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD mkdir -p $HOME/Pictures/Screenshots
      '';
    };

    wayland.windowManager.hyprland.settings = let
      screenshot = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.take-screenshot;
    in {
      bindd = [
        ", Print, Screenshot: Window, exec, ${screenshot} active"
        "SHIFT, Print, Screenshot: Area, exec, ${screenshot} area"
        "ALT, Print, Screenshot: Screen, exec, ${screenshot} output"
        "CTRL, Print, Screenshot: All, exec, ${screenshot} screen"
        "SUPER, Print, Color picker, exec, pkill hyprpicker || hyprpicker -a"
      ];
    };
  };
  perSystem = {pkgs, ...}: {
    packages.take-screenshot = app pkgs;
  };
}
