{ inputs, ... }: {
  # Enable flake-parts modules system
  # This allows multiple files to contribute to flake.modules.nixos.* and flake.modules.homeManager.*
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];
}
