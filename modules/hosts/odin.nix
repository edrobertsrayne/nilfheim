{inputs, ...}: {
  flake.modules.darwin.odin = {
    imports = with inputs.self.modules.darwin; [
      zsh
    ];
  };

  flake.modules.home.odin = {
    imports = with inputs.self.modules.home; [
      utilities
      zsh
      starship
      neovim
    ];
  };
}
