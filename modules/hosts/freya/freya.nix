{inputs, ...}: {
  flake.modules.nixos.freya = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      zsh
      desktop
      nfs-client
      powerManagement
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };

  flake.modules.generic.freya = {
    imports = with inputs.self.modules.generic; [
      zsh
      starship
    ];
  };
}
