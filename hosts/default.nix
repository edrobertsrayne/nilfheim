{
  inputs,
  lib,
  self,
  ...
}: {
  flake = let
    # Roles
    common = ../roles/common.nix;
    workstation = ../roles/workstation.nix;
    laptop = ../roles/laptop.nix;
    homelab = ../roles/homelab.nix;

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
          inherit inputs lib hostname username;
        };
        modules =
          [
            ./${hostname}
            inputs.disko.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            inputs.stylix.nixosModules.stylix
            self.nixosModules.modules
            self.nixosModules.secrets
          ]
          ++ roles
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      loki = mkNixosSystem {
        hostname = "loki";
        roles = [common homelab];
      };
      freya = mkNixosSystem {
        hostname = "freya";
        extraModules = [inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s];
        roles = [common workstation laptop];
      };
    };
  };
}
