_: {
  flake.modules.home.desktop = {pkgs, ...}: {
    # Install Spotify
    home.packages = [pkgs.spotify];
  };
}
