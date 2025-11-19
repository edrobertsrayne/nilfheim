_: {
  flake.modules.nixos.node-exporter = _: {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "systemd"
        "processes"
        "filesystem"
        "thermal_zone"
      ];
    };
  };
}
