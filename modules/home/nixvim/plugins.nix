{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        # Completion - nvim-cmp (migrated from blink-cmp)
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            mapping = {
              __raw = ''
                cmp.mapping.preset.insert({
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  ['<Tab>'] = cmp.mapping.select_next_item(),
                  ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-d>'] = cmp.mapping.scroll_docs(4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(-4),
                })
              '';
            };
            sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
              {name = "luasnip";}
            ];
          };
        };

        # Snippet engine (required for cmp)
        luasnip.enable = true;

        # Snacks.nvim - Quality of life plugins
        snacks = {
          enable = true;
          settings = {
            lazygit.enabled = true;
            words.enabled = true;
            scroll = {
              enabled = true;
              animate = {
                duration = {
                  step = 15;
                  total = 250;
                };
                easing = "linear";
              };
            };
            gitbrowser.enabled = true;
            picker.enabled = true;
            explorer.enabled = true;
            bufdelete.enabled = true;
            rename.enabled = true;
            scratch.enabled = true;
            terminal.enabled = true;
            zen.enabled = true;
            statuscolumn.enabled = true;
            notifier = {
              enabled = true;
              timeout = 3000;
              topdown = true;
            };
            input.enabled = true;
            scope.enabled = true;
            dim.enabled = true;
            # Dashboard disabled - using dashboard-nvim instead
            dashboard.enabled = false;
            bigfile = {
              enabled = true;
              size = 1572864; # 1.5MB in bytes
            };
            quickfile.enabled = true;
            indent = {
              enabled = true;
              animate.enabled = true;
            };
            win.enabled = true;
            toggle.enabled = true;
          };
        };

        # Flash - Motion plugin
        flash = {
          enable = true;
          settings = {
            modes.char.keys = {
              f = "f";
              F = "F";
              t = "t";
              T = "T";
            };
          };
        };

        # Which-key - Keymap helper
        which-key = {
          enable = true;
          settings = {
            preset = "helix";
            spec = [
              {
                __unkeyed-1 = "<leader>f";
                group = "Find";
              }
              {
                __unkeyed-1 = "<leader>g";
                group = "Git";
              }
              {
                __unkeyed-1 = "<leader>s";
                group = "Search";
              }
              {
                __unkeyed-1 = "<leader>u";
                group = "UI";
              }
              {
                __unkeyed-1 = "<leader>w";
                group = "Windows";
              }
              {
                __unkeyed-1 = "<leader>x";
                group = "Diagnostics/Quickfix";
              }
              {
                __unkeyed-1 = "<leader>q";
                group = "Quit/Session";
              }
              {
                __unkeyed-1 = "<leader>c";
                group = "Code";
              }
              {
                __unkeyed-1 = "<leader>b";
                group = "Buffers";
              }
              {
                __unkeyed-1 = "<leader>t";
                group = "Terminal";
              }
              {
                __unkeyed-1 = "<leader>n";
                group = "Notifications";
              }
              {
                __unkeyed-1 = "<leader>l";
                group = "LSP";
              }
              {
                __unkeyed-1 = "<leader><tab>";
                group = "Tabs";
              }
            ];
          };
        };

        comment = {
          enable = true;
          settings = {
            toggler = {
              line = "gcc";
              block = "gbc";
            };
            opleader = {
              line = "gc";
              block = "gb";
            };
          };
        };

        nvim-surround.enable = true;
        nvim-autopairs.enable = true;

        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = false;
            signs = {
              add.text = "│";
              change.text = "│";
              delete.text = "_";
              topdelete.text = "‾";
              changedelete.text = "~";
              untracked.text = "┆";
            };
          };
        };

        # Todo comments (requires extraPlugins)
        # Configured in extraPlugins section below

        # Treesitter - Configured in languages.nix

        # Spell check
        # Using built-in spell check, enabled in options.nix

        # Lualine - Statusline
        lualine = {
          enable = true;
          settings = {
            options = {
              globalstatus = true;
              icons_enabled = true;
              theme = "tokyonight";
            };
          };
        };

        # Bufferline - Tab line
        bufferline = {
          enable = true;
          settings = {
            options = {
              diagnostics = "nvim_lsp";
              always_show_bufferline = false;
              offsets = [
                {
                  filetype = "neo-tree";
                  text = "File Explorer";
                  highlight = "Directory";
                  text_align = "left";
                }
              ];
            };
          };
        };

        # Noice - UI improvements
        noice = {
          enable = true;
          settings = {
            lsp = {
              override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
              };
            };
            presets = {
              bottom_search = true;
              command_palette = true;
              long_message_to_split = true;
              inc_rename = false;
              lsp_doc_border = false;
            };
          };
        };

        colorizer = {
          enable = true;
          settings = {
            user_default_options = {
              RGB = true;
              RRGGBB = true;
              names = false;
              RRGGBBAA = true;
              rgb_fn = true;
              hsl_fn = true;
              css = true;
              css_fn = true;
            };
          };
        };

        # Breadcrumbs (nvim-navic)
        navic = {
          enable = true;
          settings = {
            lsp.auto_attach = true;
            highlight = true;
          };
        };

        dashboard = {
          enable = true;
          settings = {
            theme = "doom";
            config = {
              header = [
                ""
                "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
                "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
                "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
                "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
                "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
                "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
                ""
              ];
              center = [
                {
                  icon = " ";
                  icon_hl = "Title";
                  desc = "Find File";
                  desc_hl = "String";
                  key = "f";
                  key_hl = "Number";
                  action = "lua require('snacks.picker').files()";
                }
                {
                  icon = " ";
                  icon_hl = "Title";
                  desc = "New File";
                  desc_hl = "String";
                  key = "n";
                  key_hl = "Number";
                  action = "ene | startinsert";
                }
                {
                  icon = " ";
                  icon_hl = "Title";
                  desc = "Find Text";
                  desc_hl = "String";
                  key = "g";
                  key_hl = "Number";
                  action = "lua require('snacks.picker').grep()";
                }
                {
                  icon = " ";
                  icon_hl = "Title";
                  desc = "Recent Files";
                  desc_hl = "String";
                  key = "r";
                  key_hl = "Number";
                  action = "lua require('snacks.picker').recent()";
                }
                {
                  icon = " ";
                  icon_hl = "Title";
                  desc = "Quit";
                  desc_hl = "String";
                  key = "q";
                  key_hl = "Number";
                  action = "qa";
                }
              ];
            };
          };
        };

        # Fidget - LSP progress
        fidget.enable = true;

        # Trouble - Diagnostics
        trouble.enable = true;

        # Tmux Navigator - Replaces broken custom code
        tmux-navigator.enable = true;

        web-devicons.enable = true;
      };

      # Extra plugins not in nixvim
      extraPlugins = with pkgs.vimPlugins; [
        rainbow-delimiters-nvim
        todo-comments-nvim
      ];

      # Extra configuration for plugins without nixvim modules
      extraConfigLua = ''
        -- Rainbow delimiters
        require('rainbow-delimiters.setup').setup({})

        -- Todo comments
        require('todo-comments').setup({
          signs = true,
          keywords = {
            FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
          },
        })
      '';
    };
  };
}
