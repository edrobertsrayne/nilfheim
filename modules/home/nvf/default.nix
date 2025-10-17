{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nvf;
in {
  options.modules.nvf = {
    enable = mkEnableOption "Enable neovim (nvf).";
  };

  imports = [
    ./plugins.nix
    ./keymaps.nix
    ./languages.nix
  ];

  config = mkIf cfg.enable {
    programs = {
      # dependencies for snacks-nvim
      ripgrep.enable = true;
      fd.enable = true;
      lazygit.enable = true;

      nvf = {
        enable = true;
        defaultEditor = true;
        enableManpages = true;
        settings = {
          vim = {
            vimAlias = true;
            viAlias = true;

            lineNumberMode = "relNumber";
            syntaxHighlighting = true;
            preventJunkFiles = true;
            bell = "none";
            searchCase = "smart";
            hideSearchHighlight = true;
            enableLuaLoader = true;

            withNodeJs = false;
            withPython3 = false;
            withRuby = false;

            clipboard = {
              enable = true;
              providers.xclip.enable = true;
              registers = "unnamedplus";
            };

            options = {
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
            };

            luaConfigPre = ''
              vim.opt.conceallevel = 2 -- Hide * markup for bold and italic
              vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
              vim.opt.formatoptions = "jcroqlnt" -- tcqj
              vim.opt.grepformat = "%f:%l:%c:%m"
              vim.opt.grepprg = "rg --vimgrep"
              vim.opt.laststatus = 3 -- global statusline
              vim.opt.list = true -- Show some invisible characters (tabs...)
              vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
              vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
              vim.opt.spelllang = { "en" }
              vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
              vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
              vim.opt.winminwidth = 5 -- Minimum window width

              -- Tmux navigator function
              local function tmux_navigate(direction)
                local tmux_cmd = {
                  h = 'tmux select-pane -L',
                  j = 'tmux select-pane -D',
                  k = 'tmux select-pane -U',
                  l = 'tmux select-pane -R'
                }

                -- Check if we're in tmux
                if vim.env.TMUX then
                  -- Try tmux navigation first
                  local result = vim.fn.system(tmux_cmd[direction] .. ' 2>/dev/null')
                  if vim.v.shell_error == 0 then
                    return
                  end
                end

                -- Fall back to vim window navigation
                vim.cmd('wincmd ' .. direction)
              end

              _G.tmux_navigate = tmux_navigate
            '';
          };
        };
      };
    };
  };
}
