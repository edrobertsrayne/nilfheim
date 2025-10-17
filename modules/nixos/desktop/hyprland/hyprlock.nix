_: {
  programs.hyprlock = {
    enable = true;
    settings = {
      # general = {
      #   disable_loading_bar = true;
      #   grace = 300;
      #   hide_cursor = true;
      #   no_fade_in = false;
      # };
      #
      # background = [
      #   {
      #     monitor = "";
      #     path = "screenshot";
      #     blur_passes = 3;
      #     blur_size = 8;
      #   }
      # ];
      #
      # input-field = [
      #   {
      #     monitor = "";
      #     size = "280, 50";
      #     position = "0, -160";
      #     halign = "center";
      #     valign = "center";
      #     dots_center = true;
      #     fade_on_empty = false;
      #     font_color = "rgb(202, 211, 245)";
      #     inner_color = "rgba(30, 30, 46, 0.8)";
      #     outer_color = "rgba(203, 166, 247, 0.8)";
      #     outline_thickness = 3;
      #     placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
      #     rounding = 10;
      #   }
      # ];
      #
      # label = [
      #   {
      #     monitor = "";
      #     text = ''cmd[update:1000] echo "<b>$(date +"%H:%M:%S")</b>"'';
      #     color = "rgba(205, 214, 244, 1.0)";
      #     font_size = 72;
      #     font_family = "Noto Sans Nerd Font";
      #     position = "0, 80";
      #     halign = "center";
      #     valign = "center";
      #     shadow_passes = 3;
      #     shadow_size = 4;
      #     shadow_color = "rgba(0, 0, 0, 0.6)";
      #   }
      # ];
    };
  };
}
