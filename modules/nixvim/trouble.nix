{inputs, ...}: let
  inherit (inputs.self.lib.nixvim) mkKeymap;
in {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.trouble.enable = true;

      keymaps = [
        (mkKeymap "n" "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics (Trouble)")
        (mkKeymap "n" "<leader>xX" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Buffer Diagnostics (Trouble)")
        (mkKeymap "n" "<leader>xL" "<cmd>Trouble loclist toggle<cr>" "Location List (Trouble)")
        (mkKeymap "n" "<leader>xQ" "<cmd>Trouble qflist toggle<cr>" "Quickfix List (Trouble)")
        (mkKeymap "n" "<leader>xt" "<cmd>TodoTrouble<cr>" "Todo (Trouble)")
        (mkKeymap "n" "<leader>xq" "<cmd>TodoQuickFix<cr>" "Todo (QuickFix)")
      ];
    };
  };
}
