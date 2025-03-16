{
  lib,
  config,
  ...
}:
with lib.custom; {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.modules.user.name} = import ../home;
    sharedModules = [
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
