{lib, ...}:
with lib; {
  # Standard proxy configuration for internal services
  mkStandardProxy = {
    port,
    extraConfig ? {},
    enableWebSockets ? true,
    enableCaching ? false,
    customHeaders ? {},
  }:
    mkMerge [
      {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = enableWebSockets;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_buffering off;

          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (
              name: value: "proxy_set_header ${name} ${value};"
            )
            customHeaders)}

          ${
            if enableCaching
            then ''
              proxy_cache_bypass $http_upgrade;
              proxy_cache_key $scheme$proxy_host$request_uri;
              proxy_cache_valid 200 302 10m;
              proxy_cache_valid 404 1m;
            ''
            else ""
          }
        '';
      }
      extraConfig
    ];

  # Proxy configuration for services requiring HTTPS upstream
  mkHttpsProxy = {
    port,
    host ? "127.0.0.1",
    extraConfig ? {},
    enableWebSockets ? true,
    skipSSLVerification ? false,
  }:
    mkMerge [
      {
        proxyPass = "https://${host}:${toString port}";
        proxyWebsockets = enableWebSockets;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_buffering off;

          ${
            if skipSSLVerification
            then ''
              proxy_ssl_verify off;
              proxy_ssl_session_reuse off;
            ''
            else ""
          }
        '';
      }
      extraConfig
    ];

  # Configuration for services serving static assets
  mkStaticAssetProxy = {
    port,
    assetPaths ? ["~* \\.(css|js|png|jpg|jpeg|gif|ico|svg)$"],
    cacheExpiry ? "1h",
    extraConfig ? {},
  }: {
    locations = mkMerge [
      {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      }
      (lib.listToAttrs (map (path: {
          name = path;
          value = {
            proxyPass = "http://127.0.0.1:${toString port}";
            extraConfig = ''
              expires ${cacheExpiry};
              add_header Cache-Control "public, immutable";
            '';
          };
        })
        assetPaths))
      extraConfig
    ];
  };

  # Security headers for public-facing services
  mkSecurityHeaders = {
    enableHSTS ? true,
    enableCSP ? true,
    customCSP ? null,
    enableXFrameOptions ? true,
    enableReferrerPolicy ? true,
    extraHeaders ? {},
  }: {
    extraConfig = ''
      ${
        if enableHSTS
        then ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        ''
        else ""
      }

      ${
        if enableCSP
        then
          if customCSP != null
          then ''
            add_header Content-Security-Policy "${customCSP}" always;
          ''
          else ''
            add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self' wss: https:;" always;
          ''
        else ""
      }

      ${
        if enableXFrameOptions
        then ''
          add_header X-Frame-Options "SAMEORIGIN" always;
        ''
        else ""
      }

      ${
        if enableReferrerPolicy
        then ''
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        ''
        else ""
      }

      add_header X-Content-Type-Options "nosniff" always;
      add_header X-XSS-Protection "1; mode=block" always;

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (
          name: value: "add_header ${name} \"${value}\" always;"
        )
        extraHeaders)}
    '';
  };

  # Rate limiting configuration
  mkRateLimit = {
    zone ? "default",
    burst ? 20,
    nodelay ? true,
    extraConfig ? "",
  }: {
    extraConfig = ''
      limit_req zone=${zone} burst=${toString burst}${
        if nodelay
        then " nodelay"
        else ""
      };
      ${extraConfig}
    '';
  };

  # IP whitelist configuration
  mkIPWhitelist = {
    allowedIPs,
    denyAll ? true,
    extraConfig ? "",
  }: {
    extraConfig = ''
      ${lib.concatStringsSep "\n" (map (ip: "allow ${ip};") allowedIPs)}
      ${
        if denyAll
        then "deny all;"
        else ""
      }
      ${extraConfig}
    '';
  };

  # Basic auth configuration
  mkBasicAuth = {
    authFile,
    realm ? "Restricted Area",
    extraConfig ? "",
  }: {
    extraConfig = ''
      auth_basic "${realm}";
      auth_basic_user_file ${authFile};
      ${extraConfig}
    '';
  };

  # WebSocket-specific configuration
  mkWebSocketProxy = {
    port,
    path ? "/",
    extraConfig ? {},
  }: {
    locations."${path}" = mkMerge [
      {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # WebSocket specific headers
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_http_version 1.1;

          # Prevent timeouts
          proxy_read_timeout 86400;
          proxy_send_timeout 86400;
        '';
      }
      extraConfig
    ];
  };

  # API endpoint proxy (with CORS support)
  mkAPIProxy = {
    port,
    path ? "/api",
    enableCORS ? false,
    corsOrigins ? ["*"],
    corsMethods ? ["GET" "POST" "PUT" "DELETE" "OPTIONS"],
    corsHeaders ? ["Authorization" "Content-Type" "Accept"],
    extraConfig ? {},
  }: {
    locations."${path}" = mkMerge [
      {
        proxyPass = "http://127.0.0.1:${toString port}";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          ${
            if enableCORS
            then ''
              add_header Access-Control-Allow-Origin "${lib.concatStringsSep " " corsOrigins}";
              add_header Access-Control-Allow-Methods "${lib.concatStringsSep ", " corsMethods}";
              add_header Access-Control-Allow-Headers "${lib.concatStringsSep ", " corsHeaders}";
              add_header Access-Control-Allow-Credentials "true";

              if ($request_method = 'OPTIONS') {
                return 204;
              }
            ''
            else ""
          }
        '';
      }
      extraConfig
    ];
  };
}
