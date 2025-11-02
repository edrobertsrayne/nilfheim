_: {
  flake.modules.generic.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.readwise = {
      name = "Readwise Reader";
      comment = "Read and annotate articles, PDFs, and more";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://read.readwise.io";
      icon = ./../../assets/icons/readwise.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };
  };
}
