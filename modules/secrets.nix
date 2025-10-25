{inputs, ...}: {
  flake.modules.nixos.nixos = {
    imports = [inputs.agenix.nixosModules.default];
    config.age.secrets = {
      tailscale.file = ../secrets/tailscale.age;
    };
  };
}
