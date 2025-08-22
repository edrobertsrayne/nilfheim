{lib, ...}: {
  # Import all library modules
  services = import ./services.nix {inherit lib;};
  constants = import ./constants.nix;
  nginx = import ./nginx.nix {inherit lib;};
  secrets = import ./secrets.nix {inherit lib;};
}