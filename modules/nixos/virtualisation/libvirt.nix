{
  config,
  lib,
  ...
}: let
  cfg = config.virtualisation.libvirt;
  inherit (config) user;
  inherit (lib) mkEnableOption mkIf;
in {
  options.virtualisation.libvirt = {
    enable = mkEnableOption "Whether to enable libvirt virtualization.";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    users.groups.libvirtd.members = ["${user.name}"];
  };
}
