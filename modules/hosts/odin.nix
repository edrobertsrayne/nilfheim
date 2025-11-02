{inputs, ...}: {
  flake.modules.generic.odin = {
    imports = with inputs.self.modules.generic; [utilities neovim];
  };
}
