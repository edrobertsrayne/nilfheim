{inputs, ...}: let
  inherit (inputs.self.nilfheim) server;
in {
  flake.modules.nixos.media = {config, ...}: let
    cfg = config.services.sabnzbd;
    url = "sabnzbd.${server.domain}";
  in {
    services = {
      sabnzbd = {
        enable = true;
        openFirewall = true;
      };
    };

    users.users.${cfg.user}.extraGroups = ["tank"];

    systemd.services.sabnzbd.preStart = ''
      if [ -f /var/lib/sabnzbd/sabnzbd.ini ]; then
        if ! grep -q "${url}" /var/lib/sabnzbd/sabnzbd.ini; then
          sed -i "s/^host_whitelist = \(.*\)$/host_whitelist = \1, ${url}/" /var/lib/sabnzbd/sabnzbd.ini
        fi
      fi
    '';

    flake.nilfheim.server.proxy.services.sabnzbd = {
      subdomain = "sabnznd.${server.domain}";
      port = 8080;
    };
  };
}
