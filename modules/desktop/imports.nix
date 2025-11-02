{inputs, ...}: {
  flake.modules.nixos.desktop.imports = with inputs.self.modules.nixos; [
    hyprland
    greetd
  ];

  flake.modules.generic.desktop.imports = with inputs.self.modules.generic; [
    neovim
    utilities
  ];
}
