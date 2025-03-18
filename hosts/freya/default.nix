{lib, ...}:
with lib.custom; {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];
}
