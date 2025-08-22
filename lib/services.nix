{lib, ...}:
with lib; let
  inherit (lib) types mkOption mkIf;
in {
  # Generic service abstraction for *arr applications
  mkArrService = {
    name,
    exporterPort,
    description,
    iconName ? name,
    useSecretApiKey ? true,
    defaultApiKey ? "",
    extraConfig ? {},
  }: {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.services.${name};
      inherit (cfg.settings.server) port;

      # Use secret if available, otherwise fall back to default
      apiKey =
        if useSecretApiKey && config.age.secrets ? "${name}-api"
        then config.age.secrets."${name}-api".path
        else cfg.apikey;
    in {
      options.services.${name} = {
        url = mkOption {
          type = types.str;
          default = "${name}.${config.homelab.domain}";
          description = "URL for ${name} proxy host.";
        };
        apikey = mkOption {
          type = types.str;
          default = defaultApiKey;
          description = "API key for ${name} service. Only used if useSecretApiKey is false.";
        };
      };

      config = mkIf cfg.enable (mkMerge [
        {
          users.users.${cfg.user}.extraGroups = ["tank"];

          services = {
            ${name} = mkMerge [
              {
                dataDir = "/srv/${name}";
                settings.auth = {
                  method = "External";
                  type = "DisabledForLocalAddresses";
                  apikey =
                    if useSecretApiKey
                    then "$(<${apiKey})"
                    else cfg.apikey;
                };
              }
              extraConfig
            ];

            prometheus = {
              exporters."exportarr-${name}" = {
                enable = true;
                environment = {
                  API_KEY =
                    if useSecretApiKey
                    then "$(<${apiKey})"
                    else cfg.apikey;
                };
                url = "http://localhost:${toString port}";
                port = exporterPort;
              };

              scrapeConfigs = [
                {
                  job_name = name;
                  static_configs = [
                    {
                      targets = ["localhost:${toString config.services.prometheus.exporters."exportarr-${name}".port}"];
                    }
                  ];
                }
              ];
            };

            homepage-dashboard.homelabServices = [
              {
                group = "Downloads";
                name = lib.strings.toUpper (lib.substring 0 1 name) + lib.substring 1 (-1) name;
                entry = {
                  href = "https://${cfg.url}";
                  icon = "${iconName}.svg";
                  siteMonitor = "http://127.0.0.1:${toString port}";
                  inherit description;
                  widget = {
                    type = name;
                    url = "http://127.0.0.1:${toString port}";
                    key =
                      if useSecretApiKey
                      then "$(<${apiKey})"
                      else cfg.apikey;
                  };
                };
              }
            ];

            nginx.virtualHosts."${cfg.url}" = {
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString port}";
                proxyWebsockets = true;
              };
            };
          };
        }
      ]);
    };
}
