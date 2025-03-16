{
  lib,
  config,
  inputs,
  ...
}:
with lib.custom; {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.modules.user.name} = import ../home;
    sharedModules = [
      inputs.nvf.homeManagerModules.default
      {
        programs.home-manager = enabled;
        manual = {
          manpages = disabled;
          html = disabled;
          json = disabled;
        };
      }
    ];
  };
}
