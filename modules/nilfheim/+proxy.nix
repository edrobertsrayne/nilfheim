{lib, ...}: {
  options.flake.nilfheim.server.proxy = with lib; {
    services = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          subdomain = mkOption {
            type = types.str;
            description = "Full subdomain for the service (e.g., 'portainer.greensroad.uk')";
          };
          port = mkOption {
            type = types.port;
            description = "Local port where the service listens";
          };
          extraConfig = mkOption {
            type = types.attrs;
            default = {};
            description = "Extra nginx location configuration";
          };
        };
      });
      default = {};
      description = "Services to proxy through nginx";
    };
  };
}
