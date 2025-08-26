{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.beets;
  constants = import ../../../../lib/constants.nix;
in {
  options.services.beets = {
    enable = mkEnableOption "Beets music library organizer";

    url = mkOption {
      type = types.str;
      default = "beets.${config.homelab.domain}";
      description = "URL for Beets web interface proxy host";
    };

    port = mkOption {
      type = types.port;
      default = constants.ports.beets;
      description = "Port for Beets web interface";
    };

    musicLibrary = mkOption {
      type = types.str;
      default = constants.paths.music;
      description = "Path to organized music library";
    };

    musicSource = mkOption {
      type = types.str;
      default = "${constants.paths.downloads}/music";
      description = "Path to source music files for import";
    };

    configFolder = mkOption {
      type = types.str;
      default = "${constants.paths.dataDir}/beets";
      description = "Directory to store Beets configuration and database";
    };

    user = mkOption {
      type = types.str;
      default = "beets";
      description = "User account under which Beets runs";
    };

    group = mkOption {
      type = types.str;
      default = "beets";
      description = "Group under which Beets runs";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open firewall for Beets web interface";
    };

    webInterface = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the web interface";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      home = cfg.configFolder;
      createHome = true;
      extraGroups = constants.userGroups;
    };

    users.groups.${cfg.group} = {};

    # Beets configuration file
    environment.etc."beets/config.yaml".text = ''
      # Core configuration
      directory: ${cfg.musicLibrary}
      library: ${cfg.configFolder}/musiclibrary.db

      # Import settings
      import:
        move: yes
        write: yes
        copy: no
        delete: no
        resume: yes
        incremental: yes
        from_scratch: no
        quiet_fallback: skip
        timid: no
        log: ${cfg.configFolder}/import.log

      # File naming template
      paths:
        default: $albumartist/$album/$track $title
        singleton: Non-Album/$artist - $title
        comp: Compilations/$album/$track $title

      # Replace problematic characters
      replace:
        '[\\/]': _
        '^\.': _
        '[\x00-\x1f]': _
        '[<>:"\?\*\|]': _
        '\.$': _
        '\s+$': ""

      # Plugins
      plugins: ${optionalString cfg.webInterface "web "}fetchart embedart scrub replaygain missing duplicates chroma lastgenre

      # Web interface
      ${optionalString cfg.webInterface ''
        web:
          host: 127.0.0.1
          port: ${toString cfg.port}
          cors: ""
          cors_supports_credentials: yes
      ''}

      # Plugin configurations
      fetchart:
        auto: yes
        cautious: yes
        cover_names: cover folder album front
        sources: filesystem coverart itunes amazon albumart

      embedart:
        auto: yes
        remove_art_file: no

      scrub:
        auto: yes

      replaygain:
        auto: yes
        backend: gstreamer

      chroma:
        auto: yes

      lastgenre:
        auto: yes
        source: album

      duplicates:
        checksum: ffmpeg
        keys: acoustid_fingerprint
    '';

    systemd.services.beets-web = mkIf cfg.webInterface {
      description = "Beets web interface";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "5s";
        WorkingDirectory = cfg.configFolder;

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Directory access
        ReadWritePaths = [cfg.configFolder cfg.musicLibrary cfg.musicSource];

        ExecStart = "${pkgs.beets}/bin/beet -c /etc/beets/config.yaml web";
      };

      environment = {
        BEETSDIR = cfg.configFolder;
      };
    };

    # Homepage integration
    services.homepage-dashboard.homelabServices = mkIf cfg.webInterface [
      {
        group = constants.serviceGroups.utilities;
        name = "Beets";
        entry = {
          href = "https://${cfg.url}";
          icon = "beets.svg";
          siteMonitor = "http://127.0.0.1:${toString cfg.port}";
          description = constants.descriptions.beets;
        };
      }
    ];

    # Nginx reverse proxy
    services.nginx.virtualHosts = mkIf cfg.webInterface {
      "${cfg.url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_buffering off;
          '';
        };
      };
    };

    # Firewall
    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall && cfg.webInterface) [cfg.port];

    # Ensure directories exist
    systemd.tmpfiles.rules = [
      "d '${cfg.configFolder}' 0755 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.musicSource}' 0755 ${cfg.user} ${cfg.group} - -"
    ];

    # Make beets available system-wide for CLI usage
    environment.systemPackages = [pkgs.beets];
  };
}
