{
  config,
  lib,
  pkgs,
  nilfheim,
  ...
}:
with lib; let
  cfg = config.services.postgresql;
in {
  config = mkIf cfg.enable {
    services.postgresql = {
      package = pkgs.postgresql_16;
      dataDir = "${nilfheim.constants.paths.dataDir}/postgresql";

      # Enable TCP/IP connections
      enableTCPIP = true;

      # Authentication configuration for blocky user
      authentication = mkForce ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             postgres                                peer
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust

        # Allow blocky user from localhost and tailscale network
        host    ${config.services.blocky.postgres.database}     ${config.services.blocky.postgres.user}          127.0.0.1/32           md5
        host    ${config.services.blocky.postgres.database}     ${config.services.blocky.postgres.user}          ::1/128                md5
        host    ${config.services.blocky.postgres.database}     ${config.services.blocky.postgres.user}          100.64.0.0/10          md5

        # Allow replication connections
        local   replication     all                                     trust
        host    replication     all             127.0.0.1/32            trust
        host    replication     all             ::1/128                 trust
      '';

      # PostgreSQL configuration
      settings = {
        # Connection settings
        port = nilfheim.constants.ports.postgresql;
        max_connections = 100;
        shared_buffers = "256MB";
        effective_cache_size = "1GB";

        # Logging settings for monitoring
        log_statement = "all";
        log_min_duration_statement = 1000; # Log queries taking longer than 1s

        # Performance settings
        random_page_cost = 1.1;
        effective_io_concurrency = 200;

        # WAL settings for reliability
        wal_level = "replica";
        max_wal_size = "1GB";
        min_wal_size = "80MB";

        # Checkpoint settings
        checkpoint_completion_target = 0.9;
        checkpoint_timeout = "5min";
      };

      # Initialize database and user for Blocky
      initialScript = pkgs.writeText "postgresql-init.sql" ''
        CREATE DATABASE ${config.services.blocky.postgres.database};
        CREATE USER ${config.services.blocky.postgres.user} WITH PASSWORD '${config.services.blocky.postgres.password}';
        GRANT ALL PRIVILEGES ON DATABASE ${config.services.blocky.postgres.database} TO ${config.services.blocky.postgres.user};
        \c ${config.services.blocky.postgres.database};
        GRANT ALL ON SCHEMA public TO ${config.services.blocky.postgres.user};
        ALTER USER ${config.services.blocky.postgres.user} CREATEDB;
      '';
    };

    # Firewall configuration - allow local and tailscale connections
    networking.firewall.allowedTCPPorts = mkIf cfg.enableTCPIP [nilfheim.constants.ports.postgresql];
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = mkIf cfg.enableTCPIP [nilfheim.constants.ports.postgresql];

    # Ensure data directory has correct permissions
    systemd.tmpfiles.rules = [
      "d ${nilfheim.constants.paths.dataDir}/postgresql 0750 postgres postgres -"
    ];
  };
}
