{inputs, ...}: let
  inherit (inputs.self.lib.hosts) nixosSystem darwinSystem;
in {
  flake.nixosConfigurations = {
    freya = nixosSystem "x86_64-linux" "freya";
    thor = nixosSystem "x86_64-linux" "thor";
    odin = nixosSystem "x86_64-linux" "odin";
  };

  flake.darwinConfigurations = {
    imac = darwinSystem "x86_64-darwin" "imac";
  };
}
