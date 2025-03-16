{
  inputs,
  lib,
  ...
}: {
  flake = let
    mkNixosSystem = {
      system ? "x86_64-linux",
      hostname,
      extraModules ? [],
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs lib hostname;
        };
        modules =
          [
            ./${hostname}
            ../nixos
            inputs.disko.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
            inputs.agenix.nixosModules.default
            {
              networking.hostName = "${hostname}";
            }
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      loki = mkNixosSystem {
        hostname = "loki";
      };
    };
    homeMangerModules.defaut = ../home/default.nix;
  };
}
