{
  username ? "ed",
  lib,
  ...
}:
with lib.custom; {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../home;
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
