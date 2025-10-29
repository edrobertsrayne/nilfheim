_: {
  flake.modules.homeManager.nvf = {
    programs.nvf = {
      settings = {
        vim = {
          # ===== UI ELEMENTS =====
          # Statusline at the bottom showing file info, git status, LSP status, etc.
          statusline = {
            lualine = {
              enable = true;
            };
          };

          # Tabline at the top showing open buffers
          tabline = {
            nvimBufferline = {
              enable = true;
            };
          };

          # UI enhancements
          ui = {
            borders.enable = true; # Add borders to floating windows
            noice.enable = true; # Better UI for messages, cmdline, and popups
            colorizer.enable = true; # Highlight color codes (#fff, rgb(), etc.) with actual colors
          };
        };
      };
    };
  };
}
