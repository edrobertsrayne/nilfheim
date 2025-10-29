_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== NAVIGATION & SEARCH =====
          # Telescope: Fuzzy finder for files, text, symbols, and more
          telescope = {
            enable = true;
          };

          # Which-key: Shows available keybindings in a popup as you type
          # Essential for discovering commands and learning keymaps
          binds = {
            whichKey = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
