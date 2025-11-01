_: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    # Desktop entry
    xdg.desktopEntries.p5js = {
      name = "p5.js Editor";
      comment = "Creative coding web editor";
      exec = "${pkgs.firefox}/bin/firefox --new-window https://editor.p5js.org";
      icon = ./../../assets/icons/p5js.png;
      categories = ["Development"];
      terminal = false;
      type = "Application";
    };
  };
}
