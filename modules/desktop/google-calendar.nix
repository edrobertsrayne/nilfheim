_: {
  flake.modules.generic.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.google-calendar = {
      name = "Google Calendar";
      comment = "Google Calendar";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://calendar.google.com";
      icon = ./../../assets/icons/google-calendar.png;
      categories = ["Office"];
      terminal = false;
      type = "Application";
    };
  };
}
