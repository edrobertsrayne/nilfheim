_: {
  flake.lib.themes.tokyonight = {
    base16 = "tokyo-night-terminal-dark";
    nvf.theme = {
      name = "tokyonight";
      style = "night";
      transparent = true;
    };
    waybar = {
      background = "#1a1b26";
      foreground = "#a9b1d6";
      critical = "#f7768e";
      warning = "#e0af68";
    };
  };
}
