_: {
  flake.modules.homeManager.nixvim = {pkgs, ...}: {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        rainbow-delimiters-nvim
      ];

      extraConfigLua = ''
        require('rainbow-delimiters.setup').setup({})
      '';
    };
  };
}
