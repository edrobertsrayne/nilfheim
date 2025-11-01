_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.youtube = {
      name = "YouTube";
      comment = "Watch and share videos";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://youtube.com";
      icon = ./../../assets/icons/youtube.png;
      categories = ["AudioVideo"];
      terminal = false;
      type = "Application";
    };
  };
}
