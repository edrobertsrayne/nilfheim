_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      autoGroups = {
        checktime = {clear = true;};
        highlight_yank = {clear = true;};
        resize_splits = {clear = true;};
        last_loc = {clear = true;};
        close_with_q = {clear = true;};
        wrap_spell = {clear = true;};
        json_conceal = {clear = true;};
        auto_create_dir = {clear = true;};
      };

      autoCmd = [
        # Check if we need to reload the file when it changed
        {
          event = ["FocusGained" "TermClose" "TermLeave"];
          group = "checktime";
          callback.__raw = ''
            function()
              if vim.o.buftype ~= "nofile" then
                vim.cmd("checktime")
              end
            end
          '';
        }

        # Highlight on yank
        {
          event = ["TextYankPost"];
          group = "highlight_yank";
          callback.__raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        }

        # Resize splits if window got resized
        {
          event = ["VimResized"];
          group = "resize_splits";
          callback.__raw = ''
            function()
              local current_tab = vim.fn.tabpagenr()
              vim.cmd("tabdo wincmd =")
              vim.cmd("tabnext " .. current_tab)
            end
          '';
        }

        # Go to last location when opening a buffer
        {
          event = ["BufReadPost"];
          group = "last_loc";
          callback.__raw = ''
            function(event)
              local exclude = { "gitcommit" }
              local buf = event.buf
              if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
                return
              end
              vim.b[buf].lazyvim_last_loc = true
              local mark = vim.api.nvim_buf_get_mark(buf, '"')
              local lcount = vim.api.nvim_buf_line_count(buf)
              if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
              end
            end
          '';
        }

        # Close some filetypes with <q>
        {
          event = ["FileType"];
          group = "close_with_q";
          pattern = [
            "PlenaryTestPopup"
            "help"
            "lspinfo"
            "man"
            "notify"
            "qf"
            "query"
            "spectre_panel"
            "startuptime"
            "tsplayground"
            "neotest-output"
            "checkhealth"
            "neotest-summary"
            "neotest-output-panel"
            "snacks_dashboard"
            "snacks_notifier"
            "snacks_terminal"
            "snacks_win"
          ];
          callback.__raw = ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
            end
          '';
        }

        # Wrap and check for spell in text filetypes
        {
          event = ["FileType"];
          group = "wrap_spell";
          pattern = ["gitcommit" "markdown"];
          callback.__raw = ''
            function()
              vim.opt_local.wrap = true
              vim.opt_local.spell = true
            end
          '';
        }

        # Disable concealment in JSON files
        {
          event = ["FileType"];
          group = "json_conceal";
          pattern = ["json" "jsonc" "json5"];
          callback.__raw = ''
            function()
              vim.opt_local.conceallevel = 0
            end
          '';
        }

        # Auto create dir when saving a file, in case some intermediate directory does not exist
        {
          event = ["BufWritePre"];
          group = "auto_create_dir";
          callback.__raw = ''
            function(event)
              if event.match:match("^%w%w+:[\\/][\\/]") then
                return
              end
              local file = vim.uv.fs_realpath(event.match) or event.match
              vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
            end
          '';
        }
      ];
    };
  };
}
