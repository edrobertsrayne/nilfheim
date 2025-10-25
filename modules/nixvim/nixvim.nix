{inputs, ...}: {
  flake.modules.homeManager.nixvim = {
    imports = [
      inputs.nixvim.homeModules.default
    ];
    programs = {
      ripgrep.enable = true;
      fd.enable = true;
      lazygit.enable = true;

      nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        globals = {
          mapleader = " ";
          maplocalleader = " ";
        };
        clipboard = {
          providers = {
            wl-copy.enable = true;
          };
          register = "unnamedplus";
        };
      };
    };
  };
}
