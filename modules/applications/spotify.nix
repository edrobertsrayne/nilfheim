_: {
  flake.modules.homeManager.applications = {pkgs, ...}: {
    home.packages = [pkgs.spotify];
  };
}
