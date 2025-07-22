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
