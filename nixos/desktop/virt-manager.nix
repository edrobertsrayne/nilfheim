{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.virtManager;
  inherit (config.modules) user;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.virtManager = {
    enable = mkEnableOption "Whether to enable Virt-Manager desktop app.";
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = ["${user.name}"];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    # Declaratively add hypervisor connection
    home-manager.users.${user.name} = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
  };
}
