{
  config,
  lib,
  username,
  ...
}:
with lib; let
  cfg = config.virtualisation.docker;
in {
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enableOnBoot = true;

      # Use rootful Docker for full compatibility with Portainer and cAdvisor
      # Rootless mode is disabled to allow Docker socket access for management tools
      rootless = {
        enable = false;
        setSocketVariable = false;
      };

      # Docker daemon configuration
      daemon.settings = {
        # Log configuration - use json-file for better control
        log-driver = "json-file";
        log-opts = {
          max-size = "50m";
          max-file = "10";
        };
      };
    };

    # Add user to docker group for CLI access
    users.users.${username}.extraGroups = ["docker"];
  };
}
