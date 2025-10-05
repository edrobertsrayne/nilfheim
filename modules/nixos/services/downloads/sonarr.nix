{
  config,
  lib,
  nilfheim,
  ...
}: let
  # Use the abstraction but call it to get the actual module
  arrModule = nilfheim.services.mkArrService {
    name = "sonarr";
    exporterPort = nilfheim.constants.ports.exportarr-sonarr;
    description = nilfheim.constants.descriptions.sonarr;
    useSecretApiKey = false;
    defaultApiKey = "e6619670253d4b17baaa8a640a3aafed"; # Temporarily back to hardcoded for testing
    extraConfig = {
      settings.server.port = nilfheim.constants.ports.sonarr;
    };
  };
in
  arrModule {inherit config lib;}
