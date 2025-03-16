{
  description = "Ed's NixOS Configuration";

  outputs = inputs @ {flake-parts, ...}: let
    lib = inputs.nixpkgs.lib.extend (self: super: {
      custom = import ./lib {
        inherit inputs;
        lib = self;
      };
    });
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs.lib = lib;
    } {
      systems = ["x86_64-linux"];

      imports = [
        ./hosts
        ./nixos
      ];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            git
            tree
            neovim
            gh
          ];
        };
        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };
}
