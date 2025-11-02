_: {
  flake.modules.generic.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.gmail = {
      name = "Gmail";
      comment = "Google Mail";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://mail.google.com";
      icon = ./../../assets/icons/gmail.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };
  };
}
