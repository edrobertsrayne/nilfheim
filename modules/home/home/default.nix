{
  osConfig ? {},
  lib,
  namespace,
  ...
}: {home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "25.05");}
