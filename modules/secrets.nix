{inputs, ...}: {
  flake.modules.nixos.secrets = {
    imports = [inputs.agenix.nixosModules.default];
    config.age.secrets = {
      tailscale.file = ../secrets/tailscale.age;
    };
  };
}
