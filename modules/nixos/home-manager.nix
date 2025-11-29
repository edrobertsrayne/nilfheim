{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;

  # Base home-manager configuration
  base = config: {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [(inputs.self.modules.homeManager.${config.networking.hostName} or {})];
      home.stateVersion = "25.05";
    };
  };
in {
  flake.modules.nixos.home-manager = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = let
      baseConfig = base config;
    in
      baseConfig
      // {
        users.${username} =
          baseConfig.users.${username}
          // {
            imports =
              baseConfig.users.${username}.imports
              ++ [
                {
                  home = {
                    username = lib.mkDefault username;
                    homeDirectory = lib.mkDefault "/home/${username}";
                  };
                }
              ];
          };
        backupFileExtension = "backup";
      };
  };

  flake.modules.darwin.home-manager = {config, ...}: let
    baseConfig = base config;
  in {
    imports = [inputs.home-manager.darwinModules.home-manager];
    users.users.${username} = {
      name = "${username}";
      home = "/Users/${username}";
    };

    home-manager =
      baseConfig
      // {
        users.${username} =
          baseConfig.users.${username}
          // {
            programs.home-manager.enable = true;
          };
      };
  };
}
