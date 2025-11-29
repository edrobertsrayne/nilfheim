{inputs, ...}: {
  flake.modules.darwin.imac = {
    imports = with inputs.self.modules.darwin; [
      zsh
      stylix
      yabai
    ];
  };

  flake.modules.homeManager.imac = {...}: {
    imports = with inputs.self.modules.homeManager; [
      utilities
      zsh
      starship
      neovim
      wezterm
    ];

    programs = {
      vscode.enable = true;
    };
  };
}
