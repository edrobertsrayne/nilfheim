{inputs, ...}: {
  flake.modules.nixos.thor = _: {
    imports = with inputs.self.modules.nixos; [
      persistent-journald
      unclean-boot-detector
      smartd
      node-exporter
      smartctl-exporter
      zfs-exporter
    ];
  };
}
