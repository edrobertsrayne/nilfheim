{
  config,
  lib,
  ...
}: let
  libServices = import ../../../../lib/services.nix {inherit lib;};
  constants = import ../../../../lib/constants.nix;

  # Use the abstraction but call it to get the actual module
  arrModule = libServices.mkArrService {
    name = "lidarr";
    exporterPort = constants.ports.exportarr-lidarr;
    description = constants.descriptions.lidarr;
    useSecretApiKey = false;
    defaultApiKey = "f6a4315040e94c7c9eb2aefe5bfc4445"; # Temporarily hardcoded
    extraConfig = {
      settings.server.port = constants.ports.lidarr;
    };
  };
in
  arrModule {inherit config lib;}
