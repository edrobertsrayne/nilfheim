{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;

  # Cross-platform desktop modules
  base = with inputs.self.modules.homeManager; [
    alacritty
    firefox
    spotify
    vscode
  ];
in {
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      hyprland
      greetd
      audio
    ];

    home-manager.users.${username}.imports =
      base
      ++ (with inputs.self.modules.homeManager; [
        # Linux-specific modules
        webapps
        xdg
        hyprland
        waybar
        walker
        swayosd
      ]);
  };

  flake.modules.darwin.desktop = {
    imports = with inputs.self.modules.darwin; [
      # Darwin-specific imports if any
    ];

    home-manager.users.${username}.imports = base;
  };
}
