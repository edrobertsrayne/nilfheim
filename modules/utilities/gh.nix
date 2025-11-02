_: {
  flake.modules.homeManager.utilities = {pkgs, ...}: {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [gh-markdown-preview];
      settings = {
        git_protocol = "ssh";
        editor = "nvim";
        prompt = "enabled";
      };
    };
    home.shellAliases = {
      prs = "gh pr list";
      issues = "gh issue list";
    };
  };
}
