{
  config,
  lib,
  nilfheim,
  ...
}: let
  # Use the abstraction but call it to get the actual module
  arrModule = nilfheim.services.mkArrService {
    name = "radarr";
    exporterPort = nilfheim.constants.ports.exportarr-radarr;
    description = "Movie collection manager and downloader";
    useSecretApiKey = false;
    defaultApiKey = "45f0ce64ed8b4d34b51908c60b7a70fc"; # Temporarily hardcoded
    extraConfig = {
      settings.server.port = nilfheim.constants.ports.radarr;
    };
  };
in
  arrModule {inherit config lib;}
