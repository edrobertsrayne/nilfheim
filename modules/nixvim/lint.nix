_: {
  flake.modules.homeManager.nixvim = {pkgs, ...}: {
    home.packages = with pkgs; [
      statix
      deadnix
      markdownlint-cli
    ];

    programs.nixvim = {
      plugins.lint = {
        enable = true;

        lintersByFt = {
          nix = ["nix" "statix" "deadnix"];
          markdown = [
            "markdownlint"
            # "vale"
          ];
          #clojure = ["clj-kondo"];
          #dockerfile = ["hadolint"];
          #inko = ["inko"];
          #janet = ["janet"];
          #json = ["jsonlint"];
          #rst = ["vale"];
          #ruby = ["ruby"];
          #terraform = ["tflint"];
          #text = ["vale"];
        };

        autoCmd = {
          callback.__raw = ''
            function()
              -- Only run the linter in buffers that you can modify in order to
              -- avoid superfluous noise, notably within the handy LSP pop-ups that
              -- describe the hovered symbol using Markdown.
              if vim.opt_local.modifiable:get() then
                require('lint').try_lint()
              end
            end
          '';
          group = "lint";
          event = [
            "BufEnter"
            "BufWritePost"
            "InsertLeave"
          ];
        };
      };

      autoGroups = {
        lint = {
          clear = true;
        };
      };
    };
  };
}
