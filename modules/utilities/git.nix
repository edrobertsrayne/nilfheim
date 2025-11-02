{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) fullname email;
in {
  flake.modules.home.utilities = {
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
