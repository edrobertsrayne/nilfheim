{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];
  config.age.secrets = {
    tailscale.file = ./tailscale.age;
    mullvad.file = ./mullvad.age;
  };
}
