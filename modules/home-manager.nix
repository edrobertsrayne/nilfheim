{inputs, ...}: {
  flake.modules.nixos.home-manager = {config, ...}: let
    inherit (config.networking) hostName;
  in {
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
