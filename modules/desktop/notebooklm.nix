_: {
  flake.modules.generic.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.notebooklm = {
      name = "NotebookLM";
      comment = "AI-powered note taking and research assistant";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://notebooklm.google.com";
      icon = ./../../assets/icons/notebooklm.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };
  };
}
