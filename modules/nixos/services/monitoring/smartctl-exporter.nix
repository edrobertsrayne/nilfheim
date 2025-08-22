{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.smartctl-exporter;
in {
  options.services.smartctl-exporter = {
    enable = mkEnableOption "SMART disk monitoring with smartctl exporter";

    port = mkOption {
      type = types.port;
      default = 9633;
      description = "Port for smartctl exporter to listen on";
    };

    interval = mkOption {
      type = types.str;
      default = "60s";
      description = "Interval between SMART data collection";
    };

    devices = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["/dev/sda" "/dev/sdb" "/dev/nvme0n1"];
      description = "List of devices to monitor. If empty, auto-discovers devices.";
    };
  };

  config = mkIf cfg.enable {
    # Enable smartd for continuous monitoring
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        wall.enable = true;
        test = false;
      };
      defaults.autodetected = "-a -o on -S on -n standby,q -s (S/../.././02|L/../../6/03) -W 4,35,40";
    };

    # Install smartctl exporter
    systemd.services.smartctl-exporter = {
      description = "Smartctl Exporter for Prometheus";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        User = "smartctl-exporter";
        Group = "smartctl-exporter";
        ExecStart = let
          args =
            [
              "--web.listen-address=127.0.0.1:${toString cfg.port}"
              "--smartctl.path=${pkgs.smartmontools}/bin/smartctl"
              "--smartctl.interval=${cfg.interval}"
            ]
            ++ optionals (cfg.devices != []) (map (device: "--smartctl.device=${device}") cfg.devices);
        in "${pkgs.prometheus-smartctl-exporter}/bin/smartctl_exporter ${concatStringsSep " " args}";

        Restart = "always";
        RestartSec = "10s";

        # Security settings
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateTmp = true;

        # Allow access to devices for SMART data
        DeviceAllow = ["block-* r" "char-* r"];
      };
    };

    # Create smartctl-exporter user
    users.users.smartctl-exporter = {
      isSystemUser = true;
      group = "smartctl-exporter";
      extraGroups = ["disk"]; # Allow access to disk devices
      description = "Smartctl Exporter user";
    };

    users.groups.smartctl-exporter = {};

    # Grant smartctl-exporter access to disk devices
    services.udev.extraRules = ''
      # Allow smartctl-exporter to access disk devices for SMART monitoring
      SUBSYSTEM=="block", GROUP="smartctl-exporter", MODE="0640"
      # Allow access to NVMe character devices for SMART monitoring
      SUBSYSTEM=="nvme", GROUP="smartctl-exporter", MODE="0640"
    '';

    # Add sudoers rule to allow smartctl-exporter to run smartctl
    security.sudo.extraRules = [
      {
        users = ["smartctl-exporter"];
        commands = [
          {
            command = "${pkgs.smartmontools}/bin/smartctl";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    # Ensure required packages are installed
    environment.systemPackages = with pkgs; [
      smartmontools
      prometheus-smartctl-exporter
    ];

    # Open firewall port locally (for Prometheus scraping)
    networking.firewall.allowedTCPPorts = mkIf (cfg.port != 9633) [cfg.port];
  };
}
