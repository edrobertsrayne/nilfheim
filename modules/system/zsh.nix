{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.zsh = {
    pkgs,
    ...
  }: {
    programs.zsh.enable = true;
    users.users.${username}.shell = pkgs.zsh;

    # flake.modules.home.${config.networking.hostName}.imports = [inputs.self.modules.home.zsh];
  };
}
