{inputs, ...}: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
            untracked.text = "▎";
          };
          signs_staged = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
          };
        };
      };

      keymaps = let
        inherit (inputs.self.lib.nixvim) mkKeymap;
      in [
        (mkKeymap "n" "<leader>hs" "<cmd>Gitsigns stage_hunk<cr>" "Stage Hunk")
        (mkKeymap "n" "<leader>hr" "<cmd>Gitsigns reset_hunk<cr>" "Reset Hunk")
        (mkKeymap "n" "<leader>hp" "<cmd>Gitsigns preview_hunk<cr>" "Preview Hunk")
        (mkKeymap "n" "<leader>hb" "<cmd>Gitsigns blame_line<cr>" "Blame Line")
        (mkKeymap "n" "]h" "<cmd>Gitsigns next_hunk<cr>" "Next Hunk")
        (mkKeymap "n" "[h" "<cmd>Gitsigns prev_hunk<cr>" "Prev Hunk")
      ];
    };
  };
}
