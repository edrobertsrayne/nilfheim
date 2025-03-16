{
  inputs,
  lib,
  ...
}: {
  flake = let
    mkNixosSystem = {
      system ? "x86_64-linux",
      hostname,
      username ? "ed",
      extraModules ? [],
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs lib hostname username;
        };
        modules =
          [
            ./${hostname}
            ../nixos
            inputs.disko.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
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
