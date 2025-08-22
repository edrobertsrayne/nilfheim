{
  config,
  lib,
  ...
}: let
  libServices = import ../../../../lib/services.nix {inherit lib;};
  constants = import ../../../../lib/constants.nix;

  # Use the abstraction but call it to get the actual module
  arrModule = libServices.mkArrService {
    name = "sonarr";
    exporterPort = constants.ports.exportarr-sonarr;
    description = constants.descriptions.sonarr;
    useSecretApiKey = true;
    extraConfig = {
      settings.server.port = constants.ports.sonarr;
    };
  };
in
  arrModule {inherit config lib;}
