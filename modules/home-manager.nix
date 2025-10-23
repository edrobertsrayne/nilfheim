{inputs, ...}: {
  flake.modules.nixos.home-manager = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.networking) hostName;
    inherit (inputs.self.nilfheim.user) username;
  in {
    imports = [inputs.home-manager.nixosModules.home-manager];
    users.users."${username}".shell = pkgs.zsh;
    programs.zsh.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."${username}".imports = with inputs.self.modules.homeManager; [
        user
        (inputs.self.modules.homeManager."${hostName}" or {})

        {
          home.stateVersion = "25.05";
        }
      ];
    };
  };
}
