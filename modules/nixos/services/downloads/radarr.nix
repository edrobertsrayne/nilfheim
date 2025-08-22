{
  config,
  lib,
  ...
}: let
  libServices = import ../../../../lib/services.nix {inherit lib;};
  constants = import ../../../../lib/constants.nix;

  # Use the abstraction but call it to get the actual module
  arrModule = libServices.mkArrService {
    name = "radarr";
    exporterPort = constants.ports.exportarr-radarr;
    description = constants.descriptions.radarr;
    useSecretApiKey = false;
    defaultApiKey = "45f0ce64ed8b4d34b51908c60b7a70fc"; # Temporarily hardcoded
    extraConfig = {
      settings.server.port = constants.ports.radarr;
    };
  };
in
  arrModule {inherit config lib;}
