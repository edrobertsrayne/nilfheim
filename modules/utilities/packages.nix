_: {
  flake.modules.generic.utilities = {pkgs, ...}: {
    home.packages = with pkgs; [
    ];
  };
}
