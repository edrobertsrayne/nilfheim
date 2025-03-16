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
        specialArgs = {inherit inputs lib;};
        modules =
          [
            ./${hostname}
            ../nixos
            inputs.disko.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
            inputs.agenix.nixosModules.default
            {
              networking.hostName = "${hostname}";
              system.stateVersion = "25.05";
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
  };
}
