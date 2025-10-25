{inputs, ...}: {
  flake.modules.nixos.nixos.imports = [
    inputs.disko.nixosModules.disko
  ];
}
