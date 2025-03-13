{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.addons.wezterm;
in {
  options.${namespace}.desktop.addons.wezterm = with types; {
    enable = mkBoolOpt false "Whether to enable the wezterm terminal emulator.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [wezterm];
    # ${namespace}.home.configFile."wezterm/wezterm.lua" = ./wezterm.lua;
  };
}
