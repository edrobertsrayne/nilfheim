{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim.autoCmd = [
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
}
