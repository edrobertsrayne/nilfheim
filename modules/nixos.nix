{inputs, ...}: {
  flake.modules.nixos.nixos.imports = with inputs.self.modules.nixos; [
    grub
    user
    networking
    nix
    ssh
    avahi

    {
      system.stateVersion = "25.05";
    }
  ];
}
