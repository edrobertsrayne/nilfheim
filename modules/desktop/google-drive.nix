_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.google-drive = {
      name = "Google Drive";
      comment = "Google Drive cloud storage";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://drive.google.com";
      icon = ./../../assets/icons/google-drive.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };
  };
}
