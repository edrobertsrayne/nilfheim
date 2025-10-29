_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== UTILITY PLUGINS =====
          # Automatically close brackets, quotes, and other pairs
          autopairs = {
            nvim-autopairs.enable = true;
          };

          # Easy commenting/uncommenting of code
          comments = {
            comment-nvim.enable = true;
          };

          # Manipulate surrounding characters (quotes, brackets, tags)
          # Example: cs"' changes "hello" to 'hello'
          utility = {
            surround.enable = true;
            motion = {
              hop.enable = true; # Quick jump navigation - press a key combo and jump to any visible word
            };
          };
        };
      };
    };
  };
}
