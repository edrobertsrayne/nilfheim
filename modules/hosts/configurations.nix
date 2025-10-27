{inputs, ...}: let
  inherit (inputs.self.lib.hosts) nixosSystem;
in {
  flake.nixosConfigurations = {
    freya = nixosSystem "x86_64-linux" "freya";
    thor = nixosSystem "x86_64-linux" "thor";
  };
}
