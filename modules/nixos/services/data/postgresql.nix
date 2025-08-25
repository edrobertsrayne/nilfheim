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
      port = constants.ports.postgresql;

      # Authentication configuration
      authentication = ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             postgres                                peer
        local   all             all                                     md5
        host    blocky_logs     blocky          127.0.0.1/32           md5
        host    blocky_logs     blocky          ::1/128                md5
      '';

      # PostgreSQL configuration
      settings = {
        # Connection settings
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
        CREATE DATABASE blocky_logs;
        CREATE USER blocky WITH PASSWORD 'placeholder';
        GRANT ALL PRIVILEGES ON DATABASE blocky_logs TO blocky;
        \c blocky_logs;
        GRANT ALL ON SCHEMA public TO blocky;
        ALTER USER blocky CREATEDB;
      '';
    };

    # Set up proper password from agenix secret after service starts
    systemd.services.postgresql-setup-blocky = {
      description = "Setup Blocky PostgreSQL user password";
      after = ["postgresql.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
        RemainAfterExit = true;
      };

      script = ''
        # Wait for PostgreSQL to be ready
        while ! ${cfg.package}/bin/pg_isready -h localhost -p ${toString constants.ports.postgresql} -U postgres; do
          sleep 1
        done

        # Set the actual password from secret
        PASSWORD=$(cat ${config.age.secrets.postgresql-blocky-password.path})
        ${cfg.package}/bin/psql -c "ALTER USER blocky PASSWORD '$PASSWORD';"
      '';
    };

    # Firewall configuration - only allow local connections
    networking.firewall.allowedTCPPorts = mkIf cfg.enableTCPIP [];

    # Create database user group for file permissions
    users.groups.blocky-db = {};

    # Ensure data directory has correct permissions
    systemd.tmpfiles.rules = [
      "d ${constants.paths.dataDir}/postgresql 0750 postgres postgres -"
    ];
  };
}
