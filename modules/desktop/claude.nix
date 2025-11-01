_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.claude = {
      name = "Claude (Web)";
      comment = "AI assistant by Anthropic";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://claude.ai";
      icon = ./../../assets/icons/claude-ai.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };
  };
}
