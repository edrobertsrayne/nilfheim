_: {
  flake.modules.generic.desktop = {pkgs, ...}: {
    # Install Spotify
    home.packages = [pkgs.spotify];
  };
}
