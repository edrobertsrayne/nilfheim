{
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  services.qemuGuest.enable = true;
  modules.system.persist.filesystem = "zfs";
}
