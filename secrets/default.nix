{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];
  config.age.secrets = {
    tailscale.file = ./tailscale.age;
    homepage.file = ./homepage.age;
    autobrr.file = ./autobrr.age;
    kavita.file = ./kavita.age;
  };
}
