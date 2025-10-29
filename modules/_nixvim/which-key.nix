{inputs, ...}: let
  inherit (inputs.self.lib.nixvim) mkKeymap;
in {
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      plugins.which-key = {
        enable = true;

        settings = {
          delay = 0;
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "Search";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "UI";
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "Windows";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "Diagnostics/Quickfix";
            }
            {
              __unkeyed-1 = "<leader>q";
              group = "Quit/Session";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffers";
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "Terminal";
            }
            {
              __unkeyed-1 = "<leader>n";
              group = "Notifications";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "LSP";
            }
            {
              __unkeyed-1 = "<leader><tab>";
              group = "Tabs";
            }
          ];
        };
      };

      keymaps = [
        (mkKeymap "n" "<leader>?" "<cmd>WhichKey<cr>" "Buffer Keymaps (which-key)")
      ];
    };
  };
}
