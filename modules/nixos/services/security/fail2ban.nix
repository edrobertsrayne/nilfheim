{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.fail2ban;
in {
  config = mkIf cfg.enable {
    services.fail2ban = {
      bantime = "24h"; # Ban for 24 hours
      bantime-increment = {
        enable = true;
        rndtime = "8m";
        overalljails = true;
        maxtime = "168h"; # Max ban time of 7 days
      };

      jails = {
        # SSH brute force protection
        sshd = {
          settings = {
            enabled = true;
            port = "ssh";
            filter = "sshd";
            logpath = "/var/log/auth.log";
            maxretry = 3;
            findtime = "10m";
          };
        };

        # Nginx HTTP auth failures
        nginx-http-auth = {
          settings = {
            enabled = true;
            port = "http,https";
            filter = "nginx-http-auth";
            logpath = "/var/log/nginx/error.log";
            maxretry = 3;
            findtime = "10m";
          };
        };

        # Nginx request limit protection
        nginx-req-limit = {
          settings = {
            enabled = true;
            port = "http,https";
            filter = "nginx-req-limit";
            logpath = "/var/log/nginx/error.log";
            maxretry = 10;
            findtime = "10m";
          };
        };

        # General nginx bad requests
        nginx-bad-request = {
          settings = {
            enabled = true;
            port = "http,https";
            filter = "nginx-bad-request";
            logpath = "/var/log/nginx/access.log";
            maxretry = 10;
            findtime = "10m";
          };
        };
      };
    };

    # Create custom filter for nginx bad requests
    environment.etc."fail2ban/filter.d/nginx-bad-request.conf".text = ''
      [Definition]
      failregex = ^<HOST> -.*"(GET|POST|HEAD).*HTTP.*" (4|5)\d\d
      ignoreregex =
    '';

    # Ensure proper log permissions for fail2ban
    systemd.tmpfiles.rules = [
      "d /var/log/fail2ban 0755 root root -"
    ];
  };
}
