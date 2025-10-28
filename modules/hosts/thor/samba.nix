{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.thor = {
    # Create share directories
    systemd.tmpfiles.rules = [
      "d /mnt/downloads 2775 root tank"
      "d /mnt/media 2775 root tank"
      "d /mnt/backup 2775 root tank"
      "d /mnt/share 2775 root tank"
    ];

    # Configure Samba
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        downloads = {
          path = "/mnt/downloads";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "force user" = username;
          "force group" = "tank";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        media = {
          path = "/mnt/media";
          browseable = "yes";
          "read only" = "yes";
          "guest ok" = "yes";
          "force user" = username;
          "force group" = "tank";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        backup = {
          path = "/mnt/backup";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "force user" = username;
          "force group" = "tank";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        share = {
          path = "/mnt/share";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "force user" = username;
          "force group" = "tank";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
      };
    };

    # Windows network discovery
    services.samba-wsdd.enable = true;
  };
}
