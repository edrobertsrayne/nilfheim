{
  inputs,
  lib,
  ...
}: {
  flake = let
    mkNixosSystem = {
      system ? "x86_64-linux",
      username ? "ed",
      hostname,
      extraModules ? [],
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs lib hostname;};
        modules =
          [
            ./${hostname}
            ../nixos
            inputs.disko.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
            inputs.agenix.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              networking.hostName = "${hostname}";
              system.stateVersion = "25.05";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackagers = true;
                extraSpecialArrgs = {inherit inputs lib;};
                users.${username} = import ../home;
              };
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
