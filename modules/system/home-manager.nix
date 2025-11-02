{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.home-manager = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."${username}".imports = with inputs.self.modules.generic; [
        (inputs.self.modules.generic."${config.networking.hostName}" or {})
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

  flake.modules.darwin.home-manager = {config, ...}: let
    inherit (inputs.self.nilfheim.user) username;
  in {
    imports = [inputs.home-manager.darwinModules.home-manager];
    users.users."${username}" = {
      name = "${username}";
      home = "/Users/${username}";
    };
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = {
        imports = [(inputs.self.modules.generic.${config.networking.hostName} or {})];
        programs.home-manager.enable = true;
        home = {
          stateVersion = "25.05";
        };
      };
    };
  };
}
