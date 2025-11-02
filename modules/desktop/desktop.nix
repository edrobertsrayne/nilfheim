{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  # NixOS desktop aggregator
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      hyprland
      greetd
    ];

    # Platform-specific home modules
    home-manager.users.${username}.imports = with inputs.self.modules.generic; [
      desktop # Cross-platform GUI apps
      webapps # Web apps with keybinds
      xdg # XDG/MIME config
      hyprland # Hyprland user config
      waybar # Status bar
      walker # App launcher
      swayosd # OSD
    ];
  };

  # Darwin desktop aggregator
  flake.modules.darwin.desktop = {
    imports = with inputs.self.modules.darwin; [
      # Darwin-specific imports if any
    ];

    # Cross-platform home modules only
    home-manager.users.${username}.imports = with inputs.self.modules.generic; [
      desktop # Same cross-platform GUI apps
      # No Linux-specific modules
    ];
  };
}
