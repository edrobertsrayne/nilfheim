{
  imports = [
    ./alertmanager.nix
    ./glances.nix
    ./grafana.nix
    ./loki.nix
    ./prometheus.nix
    ./promtail.nix
    ./service-health.nix
    ./smartctl-exporter.nix
    ./uptime-kuma.nix
    ./zfs-exporter.nix
  ];
}
