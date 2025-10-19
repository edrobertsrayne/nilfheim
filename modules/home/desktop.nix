{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkEnableOption "Enable desktop environment configuration.";
    terminal = mkOption {
      default = lib.getExe pkgs.alacritty;
      type = types.str;
      description = "Default terminal emulator";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      TERMINAL = cfg.terminal;
    };

    desktop = {
      alacritty.enable = true;
      waybar.enable = true;
      walker.enable = true;
      wlogout.enable = true;
      zathura.enable = true;
      swaync.enable = true;
    };

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
