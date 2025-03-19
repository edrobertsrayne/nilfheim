{lib, ...}: let
  inherit (lib.custom) enabled;
in {
  nixos.services = {
    blocky = enabled;
  };
}
