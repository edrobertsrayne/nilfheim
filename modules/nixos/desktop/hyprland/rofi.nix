{pkgs, ...}: {
  # Rofi application launcher configuration
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "foot";
    font = "Noto Sans Nerd Font 14";
    extraConfig = {
      modi = "drun,run";
      icon-theme = "Papirus";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = " Apps ";
      display-run = " Run ";
      sidebar-mode = true;
    };
    theme = {
      window = {
        border-radius = "8px";
      };
      element = {
        border-radius = "4px";
      };
      inputbar = {
        border-radius = "6px";
      };
    };
  };
}
