{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) fullname email;
in {
  flake.modules.generic.utilities = {
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
