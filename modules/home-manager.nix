{inputs, ...}: {
  flake.modules.nixos.home-manager = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.networking) hostName;
  in {
    users.users.ed.shell = pkgs.zsh;
    programs.zsh.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.ed.imports = with inputs.self.modules.homeManager; [
        user
        (inputs.self.modules.homeManager."${hostName}" or {})

        {
          home.stateVersion = "25.05";
        }
      ];
    };
  };
}
