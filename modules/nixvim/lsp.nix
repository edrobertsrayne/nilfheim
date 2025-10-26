_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      autoGroups = {
        "kickstat-lsp-attach" = {
          clear = true;
        };
      };

      plugins = {
        fidget.enable = true;
        trouble.enable = true;

        lazydev = {
          enable = true;
          settings.library = [
            {
              path = "\${3rd}/luv/library";
              words = ["vim%.uv"];
            }
          ];
        };

        nvim-lightbulb = {
          enable = true;
          settings = {
            autocmd.enabled = true;
            sign.enabled = false;
            virtual_text.enabled = true;
          };
        };

        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            gopls.enable = true;
            lua_ls.enable = true;
            nixd.enable = true;
            pyright.enable = true;
            marksman.enable = true;
            yamlls.enable = true;
          };
        };
      };
    };
  };
}
