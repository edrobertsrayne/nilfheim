_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.which-key = {
      enable = true;

      settings = {
        delay = 0;
        spec = [
          {
            __unkeyed-1 = "<leader>s";
            group = "[S]earch";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "[T]oggle";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "Git [H]unk";
            mode = [
              "n"
              "v"
              "o"
              "x"
            ];
          }
        ];
      };
    };
  };
}
