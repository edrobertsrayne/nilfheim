{inputs, ...}: let
  inherit (inputs.self.nilfheim.theme) nvf;
in {
  flake.modules.homeManager.nvf = {
    imports = [inputs.nvf.homeManagerModules.default];

    # Disable stylix theming for nvf - we'll use nvf's own theme system
    stylix.targets.nvf.enable = false;

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          # ===== CORE SETTINGS =====
          # Enable vi/vim command aliases for compatibility
          viAlias = true;
          vimAlias = true;

          theme = {
            enable = true;
            inherit (nvf.theme) name style transparent;
          };

          # ===== LSP (Language Server Protocol) =====
          # LSP provides intelligent code features like autocomplete, go-to-definition,
          # error checking, and refactoring across multiple languages
          lsp = {
            enable = true;
            formatOnSave = true; # Automatically format files when saving
            lightbulb.enable = true; # Show lightbulb icon when code actions are available
            lspkind.enable = true; # Add icons to completion menu showing item type (function, variable, etc.)
          };

          # ===== LANGUAGE SUPPORT =====
          # nvf provides integrated language modules that bundle LSP, treesitter,
          # formatting, and diagnostics for specific languages
          languages = {
            nix = {
              enable = true;
              lsp = {
                enable = true; # Enable nixd LSP server for Nix intelligence
              };
              format = {
                enable = true;
                type = "alejandra"; # Use alejandra as the Nix formatter
              };
              extraDiagnostics = {
                enable = true;
                types = ["statix" "deadnix"]; # Additional linters: statix (anti-patterns), deadnix (unused code)
              };
            };
          };

          # ===== TREESITTER =====
          # Treesitter provides advanced syntax highlighting and code understanding
          # by parsing code into an Abstract Syntax Tree (AST)
          treesitter = {
            enable = true;
            fold = true; # Enable code folding based on treesitter's understanding
          };

          # ===== COMPLETION =====
          # Autocomplete engine that shows suggestions as you type
          autocomplete = {
            nvim-cmp = {
              enable = true; # Using nvim-cmp as the completion engine
            };
          };

          # Snippet engine for expanding code templates
          snippets = {
            luasnip.enable = true;
          };

          # ===== NAVIGATION & SEARCH =====
          # Telescope: Fuzzy finder for files, text, symbols, and more
          telescope = {
            enable = true;
          };

          # Which-key: Shows available keybindings in a popup as you type
          # Essential for discovering commands and learning keymaps
          binds = {
            whichKey = {
              enable = true;
            };
          };

          # ===== UI ELEMENTS =====
          # Statusline at the bottom showing file info, git status, LSP status, etc.
          statusline = {
            lualine = {
              enable = true;
            };
          };

          # Tabline at the top showing open buffers
          tabline = {
            nvimBufferline = {
              enable = true;
            };
          };

          # UI enhancements
          ui = {
            borders.enable = true; # Add borders to floating windows
            noice.enable = true; # Better UI for messages, cmdline, and popups
            colorizer.enable = true; # Highlight color codes (#fff, rgb(), etc.) with actual colors
          };

          # ===== GIT INTEGRATION =====
          git = {
            enable = true;
            # Show git diff indicators in the gutter (added/changed/removed lines)
            gitsigns = {
              enable = true;
            };
          };

          # ===== UTILITY PLUGINS =====
          # Automatically close brackets, quotes, and other pairs
          autopairs = {
            nvim-autopairs.enable = true;
          };

          # Easy commenting/uncommenting of code
          comments = {
            comment-nvim.enable = true;
          };

          # Manipulate surrounding characters (quotes, brackets, tags)
          # Example: cs"' changes "hello" to 'hello'
          utility = {
            surround.enable = true;
            motion = {
              hop.enable = true; # Quick jump navigation - press a key combo and jump to any visible word
            };
          };

          # ===== EDITOR OPTIONS =====
          # Core vim settings for editing behavior
          options = {
            # Indentation
            tabstop = 2; # Tab character displays as 2 spaces
            shiftwidth = 2; # Indent/dedent by 2 spaces
            expandtab = true; # Use spaces instead of tab characters
            autoindent = true;
            smartindent = true;

            # Line numbers
            number = true; # Show absolute line numbers
            relativenumber = true; # Show relative line numbers (great for motion commands like 5j)

            # Search
            ignorecase = true; # Case-insensitive search...
            smartcase = true; # ...unless search contains uppercase letters

            # UI
            termguicolors = true; # Enable 24-bit RGB colors
            signcolumn = "yes"; # Always show sign column (prevents text shifting when signs appear)
            cursorline = true; # Highlight the current line
            scrolloff = 8; # Keep 8 lines visible above/below cursor when scrolling
            wrap = false; # Don't wrap long lines

            # Editing
            mouse = "a"; # Enable mouse support in all modes
            clipboard = "unnamedplus"; # Use system clipboard
            undofile = true; # Persistent undo history across sessions
            swapfile = false; # Disable swap files (we have persistent undo)
          };

          # ===== KEYMAPS =====
          # Custom key bindings (LazyVim-inspired)
          # Leader key is <Space> by default in nvf
          maps = {
            normal = {
              # === General ===
              # Quick save
              "<leader>w" = {
                action = ":w<CR>";
                desc = "Save file";
              };

              # === LSP ===
              # Hover documentation
              "K" = {
                action = "vim.lsp.buf.hover";
                lua = true;
                desc = "Hover documentation";
              };
              # Go to definition
              "gd" = {
                action = "vim.lsp.buf.definition";
                lua = true;
                desc = "Go to definition";
              };
              # Go to references
              "gr" = {
                action = "vim.lsp.buf.references";
                lua = true;
                desc = "Go to references";
              };
              # Code actions
              "<leader>ca" = {
                action = "vim.lsp.buf.code_action";
                lua = true;
                desc = "Code actions";
              };
              # Rename symbol
              "<leader>cr" = {
                action = "vim.lsp.buf.rename";
                lua = true;
                desc = "Rename symbol";
              };

              # === Telescope (Find) ===
              "<leader>ff" = {
                action = "<cmd>Telescope find_files<CR>";
                desc = "Find files";
              };
              "<leader>fg" = {
                action = "<cmd>Telescope live_grep<CR>";
                desc = "Find text (grep)";
              };
              "<leader>fb" = {
                action = "<cmd>Telescope buffers<CR>";
                desc = "Find buffers";
              };
              "<leader>fr" = {
                action = "<cmd>Telescope oldfiles<CR>";
                desc = "Find recent files";
              };
              "<leader>fs" = {
                action = "<cmd>Telescope lsp_document_symbols<CR>";
                desc = "Find symbols";
              };

              # === Buffer management ===
              "<leader>bd" = {
                action = ":bdelete<CR>";
                desc = "Delete buffer";
              };
              "<S-h>" = {
                action = ":bprevious<CR>";
                desc = "Previous buffer";
              };
              "<S-l>" = {
                action = ":bnext<CR>";
                desc = "Next buffer";
              };

              # === Window navigation ===
              "<C-h>" = {
                action = "<C-w>h";
                desc = "Move to left window";
              };
              "<C-j>" = {
                action = "<C-w>j";
                desc = "Move to bottom window";
              };
              "<C-k>" = {
                action = "<C-w>k";
                desc = "Move to top window";
              };
              "<C-l>" = {
                action = "<C-w>l";
                desc = "Move to right window";
              };

              # === Better n/N (center search results) ===
              "n" = {
                action = "nzzzv";
                desc = "Next search result";
              };
              "N" = {
                action = "Nzzzv";
                desc = "Previous search result";
              };
            };

            # Insert mode mappings
            insert = {
              # Quick escape
              "jk" = {
                action = "<Esc>";
                desc = "Exit insert mode";
              };
            };

            # Visual mode mappings
            visual = {
              # Keep selection after indent
              "<" = {
                action = "<gv";
                desc = "Indent left";
              };
              ">" = {
                action = ">gv";
                desc = "Indent right";
              };

              # Move lines up/down
              "J" = {
                action = ":m '>+1<CR>gv=gv";
                desc = "Move line down";
              };
              "K" = {
                action = ":m '<-2<CR>gv=gv";
                desc = "Move line up";
              };
            };
          };
        };
      };
    };
  };
}
