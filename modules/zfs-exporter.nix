_: {
  flake.modules.nixos.zfs-exporter = _: {
    services.prometheus.exporters.zfs = {
      enable = true;
      port = 9134;
    };
  };
}
