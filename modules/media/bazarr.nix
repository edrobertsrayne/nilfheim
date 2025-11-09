{inputs, ...}: let
  inherit (inputs.self.niflheim.server) domain;
in {
  flake.modules.nixos.media = {config, ...}: let
    cfg = config.services.bazarr;
    url = "bazarr.${domain}";
  in {
    users.users.${cfg.user}.extraGroups = ["tank"];
    services = {
      bazarr = {
        enable = true;
        dataDir = "/srv/bazarr";
      };
      nginx.virtualHosts."${url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString cfg.listenPort}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
