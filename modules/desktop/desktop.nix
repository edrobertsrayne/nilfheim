{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      hyprland
      greetd
      audio
    ];

    home-manager.users.${username}.imports = with inputs.self.modules.homeManager; [
      desktop
      webapps
      xdg
      hyprland
      waybar
      walker
      swayosd
      applications
    ];
  };

  flake.modules.darwin.desktop = {
    imports = with inputs.self.modules.darwin; [
      # Darwin-specific imports if any
    ];

    home-manager.users.${username}.imports = with inputs.self.modules.homeManager; [
      desktop
      applications
    ];
  };
}
