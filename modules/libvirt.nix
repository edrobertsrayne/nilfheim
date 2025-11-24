{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.libvirt = {pkgs, ...}: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    users.users.${username}.extraGroups = ["libvirtd"];

    environment.systemPackages = with pkgs; [virt-viewer];
  };
}
