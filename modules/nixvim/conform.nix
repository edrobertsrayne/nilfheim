_: {
  flake.modules.homeManager.nixvim = {pkgs, ...}: {
    programs.nixvim = {
      extraPackages = with pkgs; [
        stylua
        shfmt
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
            lua = ["stylua"];
            nix = ["alejandra"];
            markdown = ["prettier"];
            python = ["black"];
            yaml = ["prettier"];
          };
        };
      };
    };
  };
}
