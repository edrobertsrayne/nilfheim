{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.nixos = {
    virtualisation.docker = {
      enable = true;
    };
    users.users.${username}.extraGroups = ["docker"];
  };
}
