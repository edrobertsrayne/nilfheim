_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== GIT INTEGRATION =====
          git = {
            enable = true;
            # Show git diff indicators in the gutter (added/changed/removed lines)
            gitsigns = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
