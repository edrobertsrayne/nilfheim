{inputs, ...}: {
  flake.nixosConfigurations.freya = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      home-manager
      nixos
      desktop
      tank

      {
        networking.hostName = "freya";
        networking.hostId = builtins.substring 0 8 (
          builtins.hashString "sha256" "freya"
        );
      }
    ];
  };

  flake.modules.homeManager.freya = {
    imports = with inputs.self.modules.homeManager; [utilities desktop];
  };
}
