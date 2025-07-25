{lib, ...}: {
  programs.nvf.settings.vim.autocmds = with lib; [
    # Check if we need to reload the file when it changed
    {
      enable = true;
      event = ["FocusGained" "TermClose" "TermLeave"];
      group = "nvf_checktime";
      callback = mkLuaInline ''
        function()
          if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
          end
        end
      '';
    }
    {
      # Highlight on yank
      event = ["TextYankPost"];
      group = "nvf_highlight_yank";
      callback = mkLuaInline ''
        function()
          vim.highlight.on_yank()
        end
      '';
    }
    {
      # Resize splits if window got resized
      event = ["VimResized"];
      group = "nvf_resize_splits";
      callback = mkLuaInline ''
        function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end
      '';
    }
    {
      # Close some filetypes with <q>
      event = ["FileType"];
      group = "nvf_close_with_q";
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
      callback = mkLuaInline ''
        function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end
      '';
    }
    {
      # Wrap and check for spell in text filetypes
      event = ["FileType"];
      group = "nvf_wrap_spell";
      pattern = ["gitcommit" "markdown"];
      callback = mkLuaInline ''
        function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end
      '';
    }
    {
      # Auto create dir when saving a file, in case some intermediate directory does not exist
      event = ["BufWritePre"];
      group = "nvf_auto_create_dir";
      callback = mkLuaInline ''
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
}
