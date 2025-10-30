{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.home-manager = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    users.users."${username}".shell = pkgs.zsh;
    programs.zsh.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."${username}".imports = with inputs.self.modules.homeManager; [
        (inputs.self.modules.homeManager."${config.networking.hostName}" or {})
        {
          home = {
            username = lib.mkDefault username;
            homeDirectory = lib.mkDefault "/home/${username}";
            stateVersion = "25.05";
          };
        }
      ];
    };
  };

  flake.modules.darwin.home-manager = {
    config,
    pkgs,
    ...
  }: let
    inherit (inputs.self.nilfheim.user) username;
  in {
    imports = [inputs.home-manager.darwinModules.home-manager];
    users.users."${username}" = {
      shell = pkgs.zsh;
      name = "${username}";
      home = "/Users/${username}";
    };
    programs.zsh.enable = true;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = {
        imports = [(inputs.self.modules.homeManager.${config.networking.hostName} or {})];
        programs.home-manager.enable = true;
        home = {
          stateVersion = "25.05";
        };
      };
    };
  };
}
