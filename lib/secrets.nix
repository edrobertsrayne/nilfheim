{
  lib,
  config,
  ...
}:
with lib; {
  # Helper function to create age secret options
  mkSecretOption = {
    name,
    description ? "Secret for ${name}",
    defaultPath ? "/run/agenix/${name}",
    owner ? "root",
    group ? "root",
    mode ? "0400",
  }: {
    options = {
      "${name}Secret" = mkOption {
        type = types.str;
        default = defaultPath;
        inherit description;
      };
    };

    config = {
      age.secrets.${name} = {
        file = ../secrets/${name}.age;
        path = defaultPath;
        inherit owner group mode;
      };
    };
  };

  # Helper to create service-specific secret configurations
  mkServiceSecrets = {
    serviceName,
    secrets,
    owner ? serviceName,
    group ? serviceName,
    mode ? "0400",
  }: let
    secretConfigs =
      lib.mapAttrsToList (secretName: secretConfig: {
        name = "${serviceName}-${secretName}";
        value = {
          file = ../secrets/${serviceName}-${secretName}.age;
          owner = secretConfig.owner or owner;
          group = secretConfig.group or group;
          mode = secretConfig.mode or mode;
          path = secretConfig.path or "/run/agenix/${serviceName}-${secretName}";
        };
      })
      secrets;
  in
    lib.listToAttrs secretConfigs;

  # Common secret patterns for different service types
  secretPatterns = {
    # Database secrets (username, password, connection string)
    database = {serviceName}:
      mkServiceSecrets {
        inherit serviceName;
        secrets = {
          username = {};
          password = {};
          connection-string = {};
          admin-password = {};
        };
      };

    # API service secrets (API key, webhook secret, JWT secret)
    api = {serviceName}:
      mkServiceSecrets {
        inherit serviceName;
        secrets = {
          api-key = {};
          webhook-secret = {};
          jwt-secret = {};
          session-secret = {};
        };
      };

    # Authentication secrets (LDAP, OIDC, OAuth)
    auth = {serviceName}:
      mkServiceSecrets {
        inherit serviceName;
        secrets = {
          client-id = {};
          client-secret = {};
          ldap-password = {};
          oidc-secret = {};
        };
      };

    # Media service secrets (*arr API keys, Plex tokens, etc.)
    media = {serviceName}:
      mkServiceSecrets {
        inherit serviceName;
        secrets = {
          api-key = {};
          token = {};
          webhook-url = {};
        };
      };

    # Notification secrets (email, Discord, Telegram, etc.)
    notifications = {serviceName}:
      mkServiceSecrets {
        inherit serviceName;
        secrets = {
          smtp-password = {};
          discord-webhook = {};
          telegram-token = {};
          webhook-url = {};
        };
      };

    # Backup secrets (encryption keys, storage credentials)
    backup = {serviceName}:
      mkServiceSecrets {
        inherit serviceName;
        secrets = {
          encryption-key = {};
          s3-access-key = {};
          s3-secret-key = {};
          backup-password = {};
        };
      };
  };

  # Helper to generate environment files from secrets
  mkEnvironmentFile = {
    secrets,
    serviceName,
    format ? "KEY=VALUE",
  }: let
    secretEntries =
      lib.mapAttrsToList (
        key: path:
          if format == "KEY=VALUE"
          then "${lib.toUpper key}=$(cat ${path})"
          else if format == "JSON"
          then "\"${key}\": \"$(cat ${path})\""
          else "${key}=$(cat ${path})"
      )
      secrets;

    environmentScript = pkgs.writeShellScript "${serviceName}-env" ''
      ${lib.concatStringsSep "\n" secretEntries}
    '';
  in
    environmentScript;

  # Helper to create systemd service dependencies for secrets
  mkSecretDependencies = {
    secrets,
    serviceName,
  }: {
    systemd.services.${serviceName} = {
      after = map (name: "agenix-${name}.service") (lib.attrNames secrets);
      wants = map (name: "agenix-${name}.service") (lib.attrNames secrets);
    };
  };

  # Validation helper to ensure secrets exist
  mkSecretValidation = {
    secrets,
    serviceName,
  }: {
    system.checks.secrets =
      lib.mapAttrs (name: path: {
        description = "Verify ${serviceName} secret ${name} exists";
        script = ''
          if [ ! -f "${path}" ]; then
            echo "ERROR: Secret file ${path} for ${serviceName}.${name} does not exist"
            exit 1
          fi
          echo "✓ Secret ${serviceName}.${name} exists at ${path}"
        '';
      })
      secrets;
  };

  # Helper for services that need multiple secret formats
  mkMultiFormatSecrets = {
    serviceName,
    secrets,
    formats ? ["file" "env"],
  }: let
    baseSecrets = mkServiceSecrets {inherit serviceName secrets;};

    envSecrets =
      if lib.elem "env" formats
      then {
        age.secrets."${serviceName}-env" = {
          file = mkEnvironmentFile {
            inherit secrets serviceName;
            format = "KEY=VALUE";
          };
          owner = serviceName;
          group = serviceName;
          mode = "0400";
        };
      }
      else {};

    jsonSecrets =
      if lib.elem "json" formats
      then {
        age.secrets."${serviceName}-config" = {
          file = mkEnvironmentFile {
            inherit secrets serviceName;
            format = "JSON";
          };
          owner = serviceName;
          group = serviceName;
          mode = "0400";
        };
      }
      else {};
  in
    lib.mkMerge [baseSecrets envSecrets jsonSecrets];

  # Common secret validation patterns
  validators = {
    # Ensure API key is valid format (typically hex or base64)
    apiKey = path: ''
      key=$(cat ${path})
      if [[ ! $key =~ ^[a-fA-F0-9]{32,64}$ ]] && [[ ! $key =~ ^[A-Za-z0-9+/]{20,}={0,2}$ ]]; then
        echo "WARNING: API key at ${path} does not match expected format"
      fi
    '';

    # Ensure password meets minimum requirements
    password = path: ''
      password=$(cat ${path})
      if [ ${lib.strings.stringLength "$password"} -lt 12 ]; then
        echo "WARNING: Password at ${path} is shorter than 12 characters"
      fi
    '';

    # Ensure URL format is valid
    url = path: ''
      url=$(cat ${path})
      if [[ ! $url =~ ^https?:// ]]; then
        echo "ERROR: URL at ${path} is not in valid format"
        exit 1
      fi
    '';
  };
}
