{inputs, ...}: {
  flake.modules.nixos.nixos = {
    imports = [inputs.agenix.nixosModules.default];
  };
}
