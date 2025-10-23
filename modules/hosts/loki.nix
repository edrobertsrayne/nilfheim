{inputs, ...}: {
  flake.nixosConfigurations.loki = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = with inputs.self.modules.nixos; [
      home-manager
      nixos

      {
        networking.hostName = "loki";

        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
        };

        nix.settings.experimental-features = ["nix-command" "flakes"];
      }
    ];
  };

  flake.modules.homeManager.loki = {
    imports = with inputs.self.modules.homeManager; [core];
  };
}
