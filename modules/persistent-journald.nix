_: {
  flake.modules.nixos.persistent-journald = _: {
    services.journald.extraConfig = ''
      Storage=persistent
      SystemMaxUse=1G
      RuntimeMaxUse=100M
    '';
  };
}
