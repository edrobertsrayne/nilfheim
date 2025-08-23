{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.samba;
in {
  config = mkIf cfg.enable {
    services = {
      samba = {
        openFirewall = false; # Manual firewall control for security
        settings = {
          global = {
            "workgroup" = mkDefault "WORKGROUP";
            "server string" = mkDefault config.networking.hostName;
            "netbios name" = mkDefault config.networking.hostName;
            "security" = mkDefault "user";
            "invalid users" = ["root"];
            "hosts allow" = mkDefault "100.64.0.0/10 127.0.0.1 localhost"; # Tailscale CGNAT range only
            "hosts deny" = mkDefault "0.0.0.0/0";
            "guest account" = mkDefault "nobody";
            "map to guest" = mkDefault "bad user";

            # Enhanced security settings
            "server signing" = mkDefault "mandatory";
            "smb encrypt" = mkDefault "required";
            "server min protocol" = mkDefault "SMB3";
            "client min protocol" = mkDefault "SMB3";
            "restrict anonymous" = mkDefault "2";
            "null passwords" = mkDefault "no";
            "obey pam restrictions" = mkDefault "yes";
            "unix password sync" = mkDefault "yes";
            "pam password change" = mkDefault "yes";

            # Additional hardening
            "deadtime" = mkDefault "15"; # Disconnect idle connections after 15 minutes
            "socket options" = mkDefault "TCP_NODELAY IPTOS_LOWDELAY"; # Performance + security
            "log level" = mkDefault "2"; # Enhanced logging for security monitoring
            "max log size" = mkDefault "1000"; # Rotate logs
            "dns proxy" = mkDefault "no"; # Disable DNS proxy for security
            "disable netbios" = mkDefault "yes"; # Disable legacy NetBIOS
          };
        };
      };

      samba-wsdd = {
        enable = false; # Disable WSD discovery for security (not needed with tailscale)
        openFirewall = false;
      };

      avahi.extraServiceFiles = {
        smb = ''
          <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
          <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
          <type>_smb._tcp</type>
          <port>445</port>
          </service>
          </service-group>
        '';
      };
    };

    # Manual firewall rules - only allow SMB on tailscale interface
    networking.firewall = {
      interfaces.tailscale0 = {
        allowedTCPPorts = [445]; # SMB only (NetBIOS disabled for security)
      };
    };

    system.persist.extraRootDirectories = ["/etc/samba"];
  };
}
