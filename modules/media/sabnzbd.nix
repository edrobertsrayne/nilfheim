{inputs, ...}: let
  inherit (inputs.self.niflheim) server;
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
      CONFIG="/var/lib/sabnzbd/sabnzbd.ini"

      # Create download directories
      mkdir -p /mnt/media/downloads/{tv,movies}
      chown -R ${cfg.user}:${cfg.group} /mnt/media/downloads

      if [ -f "$CONFIG" ]; then
        # Update host_whitelist to include necessary hosts
        if ! grep -q "localhost" "$CONFIG"; then
          sed -i "s/^host_whitelist = \(.*\)$/host_whitelist = \1, localhost, 127.0.0.1, ${url}/" "$CONFIG"
        elif ! grep -q "${url}" "$CONFIG"; then
          sed -i "s/^host_whitelist = \(.*\)$/host_whitelist = \1, ${url}/" "$CONFIG"
        fi

        # Update local_ranges
        if grep -q "^local_ranges = ,$" "$CONFIG"; then
          sed -i "s/^local_ranges = ,$/local_ranges = 127.0.0.1, ::1/" "$CONFIG"
        fi

        # Add categories if missing
        if ! grep -q "^\[categories\]" "$CONFIG"; then
          cat >> "$CONFIG" << 'EOF'
      [categories]
      [[tv]]
      name = tv
      order = 0
      pp =
      script = Default
      dir = /mnt/media/downloads/tv
      newzbin =
      priority = -100
      [[movies]]
      name = movies
      order = 1
      pp =
      script = Default
      dir = /mnt/media/downloads/movies
      newzbin =
      priority = -100
      EOF
        fi
      fi
    '';

    services.nginx.virtualHosts."${url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Host $host;
        '';
      };
    };
  };
}
