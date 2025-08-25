{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.postgresql;
  constants = import ../../../../lib/constants.nix;
in {
  config = mkIf cfg.enable {
    services.postgresql = {
      package = pkgs.postgresql_16;
      dataDir = "${constants.paths.dataDir}/postgresql";

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
        host    ${constants.database.blocky.database}     ${constants.database.blocky.user}          127.0.0.1/32           md5
        host    ${constants.database.blocky.database}     ${constants.database.blocky.user}          ::1/128                md5
        host    ${constants.database.blocky.database}     ${constants.database.blocky.user}          100.64.0.0/10          md5

        # Allow replication connections
        local   replication     all                                     trust
        host    replication     all             127.0.0.1/32            trust
        host    replication     all             ::1/128                 trust
      '';

      # PostgreSQL configuration
      settings = {
        # Connection settings
        port = constants.ports.postgresql;
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
        CREATE DATABASE ${constants.database.blocky.database};
        CREATE USER ${constants.database.blocky.user} WITH PASSWORD '${constants.database.blocky.password}';
        GRANT ALL PRIVILEGES ON DATABASE ${constants.database.blocky.database} TO ${constants.database.blocky.user};
        \c ${constants.database.blocky.database};
        GRANT ALL ON SCHEMA public TO ${constants.database.blocky.user};
        ALTER USER ${constants.database.blocky.user} CREATEDB;
      '';
    };

    # Firewall configuration - allow local and tailscale connections
    networking.firewall.allowedTCPPorts = mkIf cfg.enableTCPIP [constants.ports.postgresql];
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = mkIf cfg.enableTCPIP [constants.ports.postgresql];

    # Ensure data directory has correct permissions
    systemd.tmpfiles.rules = [
      "d ${constants.paths.dataDir}/postgresql 0750 postgres postgres -"
    ];
  };
}
