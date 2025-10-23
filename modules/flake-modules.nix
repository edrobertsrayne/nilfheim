{ inputs, ... }: {
  # Enable flake-parts modules system
  # This allows multiple files to contribute to flake.modules.nixos.*
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
