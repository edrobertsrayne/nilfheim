{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) fullname email;
in {
  flake.modules.homeManager.utilities = {
    programs.git = {
      enable = true;
      settings.user = {
        name = "${fullname}";
        inherit email;
        init.defaultBranch = "main";
      };
    };
  };
}
