{inputs, ...}: {
  flake.modules.nixos.cloudflared = {config, ...}: let
    inherit (inputs.self.nilfheim.server) cloudflare;
  in {
    age.secrets.cloudflared.file = cloudflare.secret;
    services.cloudflared = {
      enable = true;
      tunnels."${cloudflare.tunnel}" = {
        credentialsFile = config.age.secrets.cloudflared.path;
        default = "http_status:404";
      };
    };
  };
}
