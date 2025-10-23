{inputs, ...}: {
  flake.nixosConfigurations.loki = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = with inputs.self.modules.nixos; [
      home-manager
      nixos
      desktop

      {
        networking.hostName = "loki";

        virtualisation.vmVariant.virtualisation = {
          memorySize = 4098;
          cores = 4;
          qemu.options = [
            "-device virtio-vga-gl"
            "-display sdl,gl=on,show-cursor=off"
          ];
        };

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
    imports = with inputs.self.modules.homeManager; [core desktop];
  };
}
