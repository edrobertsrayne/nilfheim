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
      # Colorscheme configuration
      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = "night";
          transparent = true;
        };
      };

      # Vim options
      opts = {
        # Editor behavior
        autoindent = true;
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        smartcase = true;
        ignorecase = true;
        scrolloff = 8;
        sidescrolloff = 8;
        wrap = false;

        # UI improvements
        number = true;
        relativenumber = true;
        signcolumn = "yes";
        colorcolumn = "120";
        cursorline = true;

        # Splits
        splitbelow = true;
        splitright = true;

        # Timeouts
        timeoutlen = 500;
        updatetime = 200;

        # Completion
        completeopt = "menu,menuone,noselect";

        # Other improvements
        conceallevel = 2;
        pumheight = 15;
        showmode = false;
        termguicolors = true;
        undofile = true;
        mouse = "a";
        laststatus = 3; # Global statusline like LazyVim

        # Folding configuration (for treesitter)
        foldlevel = 99; # Start with all folds open
        foldlevelstart = 99; # Open all folds when starting to edit
        foldcolumn = "1"; # Show fold column indicator
      };

      # Additional Lua configuration (from luaConfigPre)
      extraConfigLuaPre = ''
        -- Additional vim options that need Lua
        vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
        vim.opt.formatoptions = "jcroqlnt" -- tcqj
        vim.opt.grepformat = "%f:%l:%c:%m"
        vim.opt.grepprg = "rg --vimgrep"
        vim.opt.list = true -- Show some invisible characters (tabs...)
        vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
        vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
        vim.opt.spelllang = { "en" }
        vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
        vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
        vim.opt.winminwidth = 5 -- Minimum window width
      '';

      # Clipboard configuration
      clipboard = {
        providers.xclip.enable = true;
        register = "unnamedplus";
      };
    };
  };
}
