{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    inputs',
    ...
  }: {
    packages = {
      wallpaper = import ./wallpaper.nix {
        inherit pkgs inputs;
      };
    };
  };
}
