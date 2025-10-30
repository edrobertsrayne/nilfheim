_: {
  flake.modules.homeManager.neovim = {
    programs.nvf = {
      settings = {
        vim = {
          filetree.neo-tree.enable = true;

          maps = {
            normal = {
              "<leader>e" = {
                action = "<cmd>Neotree toggle<CR>";
                desc = "Toggle NeoTree";
              };
            };
          };
        };
      };
    };
  };
}
