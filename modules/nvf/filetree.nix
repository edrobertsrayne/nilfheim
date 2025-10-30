_: {
  flake.modules.homeManager.nvf = {
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
