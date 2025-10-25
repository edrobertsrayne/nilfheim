_: {
  flake.modules.homeManager.nixvim = {pkgs, ...}: {
    programs.nixvim = {
      extraPackages = with pkgs; [
        stylua
        shfmt
        # gofmt
        alejandra
        black
        nodePackages.prettier
      ];
      plugins.conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = false;
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            bash = ["shfmt"];
            # go = ["gofmt"];
            lua = ["stylua"];
            nix = ["alejandra"];
            markdown = ["prettier"];
            python = ["black"];
            yaml = ["prettier"];
          };
        };
      };
      keymaps = [
        {
          mode = "";
          key = "<leader>f";
          action.__raw = ''
            function()
              require('conform').format { async = true, lsp_fallback = true }
            end
          '';
          options = {
            desc = "[F]ormat buffer";
          };
        }
      ];
    };
  };
}
