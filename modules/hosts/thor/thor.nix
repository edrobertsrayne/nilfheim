{inputs, ...}: {
  flake.modules.nixos.thor = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix
    ];
  };
}
