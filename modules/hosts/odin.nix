{inputs, ...}: {
  flake.modules.homeManager.odin = {
    imports = with inputs.self.modules.homeManager; [utilities neovim];
  };
}
