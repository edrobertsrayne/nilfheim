{
  description = "Ed's NixOS Configuration";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = ["x86_64-linux" "x86_64-darwin"];

      imports = [
        ./hosts
      ];

      perSystem = {
        pkgs,
        inputs',
        system,
        lib,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs;
            [
              git
              alejandra
            ]
            ++ lib.optionals stdenv.isLinux [
              inputs'.agenix.packages.default
              inputs'.disko.packages.default
            ]
            ++ lib.optionals stdenv.isDarwin [
            ];
        };
        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };
}
