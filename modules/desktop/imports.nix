{inputs, ...}: {
  flake.modules.nixos.desktop.imports = with inputs.self.modules.nixos; [
    hyprland
    greetd
  ];

  flake.modules.homeManager.desktop.imports = with inputs.self.modules.homeManager; [
    neovim
    utilities
  ];
}
