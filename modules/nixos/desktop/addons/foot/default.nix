{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.addons.foot;
in {
  options.${namespace}.desktop.addons.foot = with types; {
    enable = mkBoolOpt false "Whether to enable foot terminal emulator.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [foot];
    ${namespace}.home.configFile."foot/foot.ini".source = ./foot.ini;
  };
}
