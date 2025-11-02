{inputs, ...}: {
  flake.modules.darwin.odin = {
    imports = with inputs.self.modules.darwin; [
      zsh
    ];
  };

  flake.modules.generic.odin = {
    imports = with inputs.self.modules.generic; [
      utilities
      zsh
      starship
      neovim
    ];
  };
}
