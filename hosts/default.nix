{inputs, ...}: {
  flake = let
    inherit (inputs.nixpkgs) lib;

    # Roles
    common = ../roles/common.nix;
    workstation = ../roles/workstation.nix;
    homelab = ../roles/homelab.nix;
    gaming = ../roles/gaming.nix;
    vps = ../roles/vps.nix;

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
          # Add our custom library namespace
          nilfheim = import ../lib {inherit lib;};
        };
        modules =
          [
            ./${hostname}
            inputs.disko.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            inputs.catppuccin.nixosModules.catppuccin
            ../modules/nixos
            ../secrets
          ]
          ++ roles
          ++ extraModules;
      };
    mkDarwinSystem = {
      system ? "x86_64-darwin",
      hostname,
      username ? "ed",
      extraModules ? [],
      roles ? [],
    }:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs lib hostname username system;
          # Add our custom library namespace
          nilfheim = import ../lib {inherit lib;};
        };
        modules =
          [
            inputs.home-manager.darwinModules.home-manager
            ../modules/darwin
            ../secrets
          ]
          ++ roles
          ++ extraModules;
      };
  in {
    nixosConfigurations = lib.optionalAttrs (builtins.getEnv "NIX_CHECK_CURRENT_SYSTEM_ONLY" == "" || builtins.currentSystem != "x86_64-darwin") {
      freya = mkNixosSystem {
        hostname = "freya";
        extraModules = [inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s];
        roles = [common workstation gaming];
      };
      thor = mkNixosSystem {
        hostname = "thor";
        roles = [homelab];
      };
      loki = mkNixosSystem {
        hostname = "loki";
        roles = [vps];
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
    darwinConfigurations = {
      odin = mkDarwinSystem {
        system = "x86_64-darwin";
        hostname = "odin";
      };
    };
  };
}
