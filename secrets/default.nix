{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];
  config.age.secrets = {
    tailscale.file = ./tailscale.age;
    homepage.file = ./homepage.age;
    autobrr.file = ./autobrr.age;
    karakeep.file = ./karakeep.age;
    kavita.file = ./kavita.age;
    cloudflare-homelab.file = ./cloudflare-homelab.age;
    # *arr service API keys
    sonarr-api.file = ./sonarr-api.age;
    radarr-api.file = ./radarr-api.age;
    lidarr-api.file = ./lidarr-api.age;
  };
}
