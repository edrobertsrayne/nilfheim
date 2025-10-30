_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          maps = {
            normal = {
              # === Save ===
              "<leader>w" = {
                action = ":w<CR>";
                desc = "Save file";
              };
              "<C-s>" = {
                action = ":w<CR>";
                desc = "Save file";
              };

              # === Buffer management ===
              "<leader>bd" = {
                action = ":bdelete<CR>";
                desc = "Delete buffer";
              };
              "<leader>bb" = {
                action = "<cmd>e #<CR>";
                desc = "Switch to alternate buffer";
              };
              "<leader>bo" = {
                action = "<cmd>%bd|e#|bd#<CR>";
                desc = "Delete other buffers";
              };
              "<leader>bD" = {
                action = "<cmd>bd<CR><cmd>close<CR>";
                desc = "Delete buffer and window";
              };
              "<S-h>" = {
                action = ":bprevious<CR>";
                desc = "Previous buffer";
              };
              "<S-l>" = {
                action = ":bnext<CR>";
                desc = "Next buffer";
              };
              "[b" = {
                action = ":bprevious<CR>";
                desc = "Previous buffer";
              };
              "]b" = {
                action = ":bnext<CR>";
                desc = "Next buffer";
              };

              # === Window navigation ===
              "<C-h>" = {
                action = "<C-w>h";
                desc = "Move to left window";
              };
              "<C-j>" = {
                action = "<C-w>j";
                desc = "Move to bottom window";
              };
              "<C-k>" = {
                action = "<C-w>k";
                desc = "Move to top window";
              };
              "<C-l>" = {
                action = "<C-w>l";
                desc = "Move to right window";
              };

              # === Window management ===
              "<leader>wd" = {
                action = "<C-w>c";
                desc = "Delete/close window";
              };
              "<leader>-" = {
                action = "<C-w>s";
                desc = "Split window horizontally";
              };
              "<leader>|" = {
                action = "<C-w>v";
                desc = "Split window vertically";
              };

              # === Window resize ===
              "<C-Up>" = {
                action = ":resize +2<CR>";
                desc = "Increase window height";
              };
              "<C-Down>" = {
                action = ":resize -2<CR>";
                desc = "Decrease window height";
              };
              "<C-Left>" = {
                action = ":vertical resize -2<CR>";
                desc = "Decrease window width";
              };
              "<C-Right>" = {
                action = ":vertical resize +2<CR>";
                desc = "Increase window width";
              };

              # === Better n/N (center search results) ===
              "n" = {
                action = "nzzzv";
                desc = "Next search result";
              };
              "N" = {
                action = "Nzzzv";
                desc = "Previous search result";
              };

              # === Clear search highlights ===
              "<Esc>" = {
                action = ":noh<CR><Esc>";
                desc = "Clear search highlights";
              };
            };

            insert = {
              "jk" = {
                action = "<Esc>";
                desc = "Exit insert mode";
              };

              # === Save in insert mode ===
              "<C-s>" = {
                action = "<Esc>:w<CR>a";
                desc = "Save file";
              };

              # === Move lines in insert mode ===
              "<A-j>" = {
                action = "<Esc>:m .+1<CR>==gi";
                desc = "Move line down";
              };
              "<A-k>" = {
                action = "<Esc>:m .-2<CR>==gi";
                desc = "Move line up";
              };
            };

            visual = {
              # Keep selection after indent
              "<" = {
                action = "<gv";
                desc = "Indent left";
              };
              ">" = {
                action = ">gv";
                desc = "Indent right";
              };

              # === Move lines in visual mode ===
              "J" = {
                action = ":m '>+1<CR>gv=gv";
                desc = "Move line down";
              };
              "K" = {
                action = ":m '<-2<CR>gv=gv";
                desc = "Move line up";
              };
              "<A-j>" = {
                action = ":m '>+1<CR>gv=gv";
                desc = "Move line down";
              };
              "<A-k>" = {
                action = ":m '<-2<CR>gv=gv";
                desc = "Move line up";
              };
            };
          };
        };
      };
    };
  };
}
