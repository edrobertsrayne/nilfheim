_: {
  flake.modules.nixos.smartctl-exporter = _: {
    services.prometheus.exporters.smartctl = {
      enable = true;
      port = 9633;
    };
  };
}
