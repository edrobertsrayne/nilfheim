{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        # Treesitter configuration
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
          folding = true;

          # Treesitter textobjects
          nixvimInjections = true;
        };

        treesitter-textobjects = {
          enable = true;
          select = {
            enable = true;
            keymaps = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
            };
          };
        };

        # LSP Configuration
        lsp = {
          enable = true;

          servers = {
            # Bash
            bashls.enable = true;

            # Go
            gopls.enable = true;

            # Lua
            lua_ls.enable = true;

            # Nix
            nixd.enable = true;

            # Markdown
            marksman.enable = true;

            # Python
            pyright.enable = true;

            # YAML
            yamlls.enable = true;
          };

          # LSP keymaps are defined in keymaps.nix
        };

        # Lightbulb - Show code action availability
        nvim-lightbulb = {
          enable = true;
          settings = {
            autocmd.enabled = true;
            sign.enabled = false;
            virtual_text.enabled = true;
          };
        };

        # Auto-formatting
        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = {
              lsp_format = "fallback";
              timeout_ms = 500;
            };
            formatters_by_ft = {
              bash = ["shfmt"];
              go = ["gofmt"];
              lua = ["stylua"];
              nix = ["alejandra"];
              markdown = ["prettier"];
              python = ["black"];
              yaml = ["prettier"];
            };
          };
        };
      };
    };
  };
}
