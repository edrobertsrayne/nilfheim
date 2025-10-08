{
  config,
  lib,
  nilfheim,
  ...
}: let
  # Use the abstraction but call it to get the actual module
  arrModule = nilfheim.services.mkArrService {
    name = "lidarr";
    exporterPort = nilfheim.constants.ports.exportarr-lidarr;
    description = "Music collection manager and downloader";
    useSecretApiKey = false;
    defaultApiKey = "f6a4315040e94c7c9eb2aefe5bfc4445"; # Temporarily hardcoded
    extraConfig = {
      settings.server.port = nilfheim.constants.ports.lidarr;
    };
  };
in
  arrModule {inherit config lib;}
