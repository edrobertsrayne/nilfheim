{inputs, ...}: let
  inherit (inputs.self.niflheim.server) domain;
in {
  flake.modules.nixos.karakeep = _: let
    url = "keep.${domain}";
  in {
    services = {
      karakeep.enable = true;
      nginx.virtualHosts."${url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081";
          proxyWebsockets = true;
        };
      };
    };
  };
}
