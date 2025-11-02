_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    # Install Spotify
    home.packages = [pkgs.spotify];
  };
}
