{ inputs, lib, ... }: {
  flake.nixosConfigurations.loki = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      # Import the feature modules we defined
      inputs.self.modules.nixos.networking
      inputs.self.modules.nixos.users

      # Inline host-specific configuration
      {
        # Set hostname
        networking.hostName = "loki";

        # Boot loader configuration
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Minimal filesystem config for VM testing
        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
        };

        # NixOS release version
        system.stateVersion = "24.11";

        # Enable flakes and nix-command
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      }
    ];
  };
}
