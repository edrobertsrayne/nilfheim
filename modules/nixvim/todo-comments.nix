{inputs, ...}: let
  inherit (inputs.self.lib.nixvim) mkKeymap;
in {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.todo-comments = {
        enable = true;
        settings = {
          signs = true;
        };
      };

      keymaps = [
        (mkKeymap "n" "]t" "<cmd>lua require('todo-comments').jump_next()<cr>" "Next Todo Comment")
        (mkKeymap "n" "[t" "<cmd>lua require('todo-comments').jump_prev()<cr>" "Prev Todo Comment")
        (mkKeymap "n" "<leader>st" "<cmd>TodoTelescope<cr>" "Todo")
        (mkKeymap "n" "<leader>sT" "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>" "Todo/Fix/Fixme")
        (mkKeymap "n" "<leader>xT" "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>" "Todo/Fix/Fixme (Trouble)")
      ];
    };
  };
}
