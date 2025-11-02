{inputs, ...}: {
  flake.modules.nixos.nixos = {
    imports = [inputs.self.modules.nixos.home-manager];
    system.stateVersion = "25.05";
  };
}
