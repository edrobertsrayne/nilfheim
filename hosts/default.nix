{
  inputs,
  lib,
  ...
}: {
  flake = let
    # Roles
    common = ../roles/common.nix;
    desktop = ../roles/desktop.nix;
    laptop = ../roles/laptop.nix;
    homelab = ../roles/homelab.nix;
    gaming = ../roles/gaming.nix;

    mkNixosSystem = {
      system ? "x86_64-linux",
      hostname,
      username ? "ed",
      extraModules ? [],
      roles ? [],
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs lib hostname username system;
        };
        modules =
          [
            ./${hostname}
            inputs.disko.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            inputs.catppuccin.nixosModules.catppuccin
            inputs.proxmox-nixos.nixosModules.proxmox-ve
            ../modules/nixos
            ../modules/common
            ../secrets
          ]
          ++ roles
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      freya = mkNixosSystem {
        hostname = "freya";
        extraModules = [inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s];
        roles = [common desktop laptop gaming];
      };
      thor = mkNixosSystem {
        hostname = "thor";
        roles = [common homelab];
      };
      iso = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({
            pkgs,
            modulesPath,
            ...
          }: {
            imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
            environment.systemPackages = [pkgs.neovim];
            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0EYKmro8pZDXNyT5NiBZnRGhQ/5HlTn5PJEWRawUN1 ed@imac"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdf/364Rgul97UR6vn4caDuuxBk9fUrRjfpMsa4sfam ed@freya"
            ];
          })
        ];
      };
    };
  };
}
