{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;

  # Cross-platform desktop modules
  base = with inputs.self.modules.homeManager; [
  ];
in {
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
    ];

    home-manager.users.${username}.imports =
      base
      ++ (with inputs.self.modules.homeManager; [
        # Linux-specific modules
      ]);
  };

  flake.modules.darwin.desktop = {
    imports = with inputs.self.modules.darwin; [
      # Darwin-specific imports if any
    ];

    home-manager.users.${username}.imports = base;
  };
}
