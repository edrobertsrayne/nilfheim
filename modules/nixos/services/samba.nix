{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.samba;
in {
  config = mkIf cfg.enable {
    services = {
      samba = {
        openFirewall = true;
        settings = {
          global = {
            "workgroup" = mkDefault "WORKGROUP";
            "server string" = mkDefault config.networking.hostName;
            "netbios name" = mkDefault config.networking.hostName;
            "security" = mkDefault "user";
            "invalid users" = ["root"];
            "hosts allow" = mkDefault "192.168.68. 127.0.0.1 localhost";
            "hosts deny" = mkDefault "0.0.0.0/0";
            "guest account" = mkDefault "nobody";
            "map to guest" = mkDefault "bad user";
          };
        };
      };

      samba-wsdd = {
        enable = true;
        openFirewall = true;
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
  };
}
