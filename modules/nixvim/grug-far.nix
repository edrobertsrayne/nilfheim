{inputs, ...}: let
  inherit (inputs.self.lib.nixvim) mkLuaKeymap;
in {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.grug-far = {
        enable = true;
        settings = {
          headerMaxWidth = 80;
        };
      };

      keymaps = [
        # ========================================
        # Search and Replace (grug-far)
        # ========================================

        (mkLuaKeymap "n" "<leader>sr" ''
          function()
            local grug = require("grug-far")
            local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
            grug.open({
              transient = true,
              prefills = {
                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
              },
            })
          end
        '' "Search and Replace")

        (mkLuaKeymap "x" "<leader>sr" ''
          function()
            local grug = require("grug-far")
            local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
            grug.open({
              transient = true,
              prefills = {
                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
              },
            })
          end
        '' "Search and Replace")
      ];
    };
  };
}
