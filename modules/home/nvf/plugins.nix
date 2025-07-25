{
  programs.nvf.settings.vim = {
    lazy = {
      enable = true;
    };
    autocomplete = {
      blink-cmp = {
        enable = true;
        setupOpts = {
          keymap = {
            preset = "enter";
            "<Tab>" = ["select_next" "fallback"];
            "<S-Tab>" = ["select_prev" "fallback"];
            "<C-Space>" = ["show" "show_documentation" "hide_documentation"];
          };
        };
      };
      nvim-cmp.enable = false;
    };
    utility = {
      motion = {
        flash-nvim = {
          enable = true;
          mappings = {
            jump = "s";
            treesitter = "S";
            remote = "r";
          };
        };
      };
      surround = {
        enable = true;
        useVendoredKeybindings = true;
      };
      snacks-nvim = {
        enable = true;
        setupOpts = {
          lazygit = {enabled = true;};
          words = {enabled = true;};
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
          gitbrowser = {enabled = true;};
          picker = {enabled = true;};
          explorer = {enabled = true;};
          bufdelete = {enabled = true;};
          rename = {enabled = true;};
          scratch = {enabled = true;};
          terminal = {enabled = true;};
          zen = {enabled = true;};
          statuscolumn = {enabled = true;};
          notifier = {
            enabled = true;
            timeout = 3000;
            topdown = true;
          };
          input = {enabled = true;};
          scope = {enabled = true;};
          dim = {enabled = true;};
          dashboard = {
            enabled = false;
            preset = {
              sections = [
                {section = "header";}
                {
                  section = "keys";
                  gap = 1;
                  padding = 1;
                }
              ];
              keys = [
                {
                  icon = " ";
                  key = "f";
                  desc = "Find File";
                  action = ":lua require('snacks.picker').files()";
                }
                {
                  icon = " ";
                  key = "n";
                  desc = "New File";
                  action = ":ene | startinsert";
                }
                {
                  icon = " ";
                  key = "g";
                  desc = "Find Text";
                  action = ":lua require('snacks.picker').grep()";
                }
                {
                  icon = " ";
                  key = "r";
                  desc = "Recent Files";
                  action = ":lua require('snacks.picker').recent()";
                }
                {
                  icon = " ";
                  key = "s";
                  desc = "Restore Session";
                  section = "session";
                }
                {
                  icon = " ";
                  key = "q";
                  desc = "Quit";
                  action = ":qa";
                }
              ];
            };
          };
          bigfile = {
            enabled = true;
            size = 1.5 * 1024 * 1024;
          };
          quickfile = {enabled = true;};
          indent = {
            enabled = true;
            animate = {
              enabled = true;
            };
          };
          win = {enabled = true;};
          toggle = {enabled = true;};
        };
      };
    };
    autopairs.nvim-autopairs.enable = true;

    dashboard.dashboard-nvim = {
      enable = true;
    };

    binds = {
      whichKey = {
        enable = true;
        setupOpts = {
          preset = "helix";
        };
        register = {
          "<leader>f" = "Find";
          "<leader>g" = "Git";
          "<leader>s" = "Search";
          "<leader>u" = "UI";
          "<leader>w" = "Windows";
          "<leader>x" = "Diagnostics/Quickfix";
          "<leader>q" = "Quit/Session";
          "<leader>c" = "Code";
          "<leader>b" = "Buffers";
          "<leader>t" = "Terminal";
          "<leader>n" = "Notifications";
          "<leader>l" = "LSP";
        };
      };
    };

    comments = {
      comment-nvim = {
        enable = true;
        mappings = {
          toggleCurrentLine = "gcc";
          toggleCurrentBlock = "gbc";
          toggleOpLeaderLine = "gc";
          toggleOpLeaderBlock = "gb";
        };
      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
      fidget-nvim.enable = true;
    };

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        mappings = {
          stageHunk = "<leader>hs";
          resetHunk = "<leader>hr";
          previewHunk = "<leader>hp";
          blameLine = "<leader>hb";
          nextHunk = "]h";
          previousHunk = "[h";
        };
      };
    };

    notes = {
      todo-comments = {
        enable = true;
        mappings = {
          # Use snacks picker for todo search
          telescope = null;
          trouble = "<leader>xt";
          quickFix = "<leader>xq";
        };
      };
    };

    snippets.luasnip.enable = true;

    spellcheck.enable = true;

    statusline = {
      lualine = {
        enable = true;
        globalStatus = true;
        icons.enable = true;
      };
    };
    tabline = {
      nvimBufferline = {
        enable = true;
        mappings = {
          cycleNext = "<S-l>";
          cyclePrevious = "<S-h>";
          # Buffer deletion handled by snacks.bufdelete
          closeCurrent = null;
          pick = "<leader>bp";
        };
      };
    };

    treesitter = {
      enable = true;
      fold = true;

      # Context disabled - snacks handles this better
      context.enable = false;

      textobjects = {
        enable = true;
        setupOpts = {
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
      };
    };
    ui = {
      colorizer = {
        enable = true;
        setupOpts = {
          filetypes = {
            "*" = {};
            css = {rgb_fn = true;};
          };
        };
      };
      borders = {
        enable = true;
        globalStyle = "rounded";
      };

      breadcrumbs = {
        enable = true;
        source = "nvim-navic";
      };

      noice = {
        enable = true;
        setupOpts = {
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
    };
  };
}
