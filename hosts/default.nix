{inputs, ...}: {
  flake = let
    mkNixosSystem = {
      system ? "x86_64-linux",
      hostname,
      extraModules ? [],
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          [
            ./${hostname}
            inputs.disko.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
            inputs.agenix.nixosModules.default
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
