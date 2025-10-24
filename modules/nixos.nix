{inputs, ...}: {
  flake.modules.nixos.nixos.imports = with inputs.self.modules.nixos; [
    inputs.disko.nixosModules.disko
    grub
    user
    networking
    nix
    ssh
    avahi
    secrets
    tailscale
    {
      system.stateVersion = "25.05";
    }
  ];
}
