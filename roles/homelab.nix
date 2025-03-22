{
  nixpkgs.config.allowUnfree = true;
  services = {
    blocky.enable = true;
    caddy.enable = true;
    plex.enable = true;
  };
}
