{inputs, ...}: {
  flake.modules.nixos.freya = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      home-manager
      desktop
      tank
      powerManagement
    ];
  };

  flake.modules.homeManager.freya = {
    imports = with inputs.self.modules.homeManager; [utilities desktop];
  };
}
