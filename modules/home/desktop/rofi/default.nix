{
  lib,
  config,
  ...
}: let
  cfg = config.desktop.rofi;
in {
  options.desktop.rofi = {
    enable = lib.mkEnableOption "Whether to enable rofi application launcher";
  };

  config = lib.mkIf cfg.enable {
    # catppuccin.rofi.enable = false;
    programs.rofi = {
      enable = true;
      terminal = "foot";
      # font = "Noto Sans Nerd Font 14";
      # extraConfig = {
      #   modi = "drun,run";
      #   icon-theme = "Papirus";
      #   show-icons = true;
      #   drun-display-format = "{icon} {name}";
      #   disable-history = false;
      #   hide-scrollbar = true;
      #   sidebar-mode = false;
      #   display-ssh = "󰣀 ssh:";
      #   display-run = "󱓞 run:";
      #   display-drun = "󰣖 apps:";
      #   display-window = "󱂬 window:";
      #   display-combi = "󰕘 combi:";
      #   display-filebrowser = "󰉋 filebrowser:";
      # };
      # theme = let
      #   inherit (config.lib.formats.rasi) mkLiteral;
      # in {
      #   window = {
      #     height = mkLiteral "600px";
      #     width = mkLiteral "600px";
      #     border = 1;
      #     border-radius = 10;
      #     border-color = mkLiteral "@lavender";
      #   };
      #
      #   mainbox = {
      #     spacing = 0;
      #     children = map mkLiteral ["inputbar" "message" "listview"];
      #   };
      #
      #   inputbar = {
      #     color = mkLiteral "@text";
      #     padding = 14;
      #     background-color = mkLiteral "@base";
      #   };
      #
      #   message = {
      #     padding = 10;
      #     background-color = mkLiteral "@overlay0";
      #   };
      #
      #   listview = {
      #     padding = 8;
      #     border-radius = mkLiteral "0 0 10 10";
      #     border = mkLiteral "2 2 2 2";
      #     border-color = mkLiteral "@base";
      #     background-color = mkLiteral "@base";
      #     dynamic = mkLiteral "false";
      #   };
      #
      #   textbox = {
      #     text-color = mkLiteral "@text";
      #     background-color = "inherit";
      #   };
      #
      #   error-message = {
      #     border = mkLiteral "20 20 20 20";
      #   };
      #
      #   entry = {
      #     text-color = mkLiteral "inherit";
      #   };
      #
      #   prompt = {
      #     text-color = mkLiteral "inherit";
      #   };
      #
      #   case-indicator = {
      #     # text-color = mkLiteral "inherit";
      #   };
      #
      #   prompt = {
      #     margin = mkLiteral "0 10 0 0";
      #   };
      #
      #   element = {
      #     padding = 5;
      #     vertical-align = mkLiteral "0.5";
      #     border-radius = 10;
      #     background-color = mkLiteral "@surface0";
      #   };
      #
      #   "element.selected.normal" = {
      #     background-color = mkLiteral "@overlay0";
      #   };
      #
      #   "element.alternate.normal" = {
      #     background-color = "inherit";
      #   };
      #
      #   "element.normal.active" = {
      #     background-color = mkLiteral "@peach";
      #   };
      #
      #   "element.alternate.active" = {
      #     background-color = mkLiteral "@peach";
      #   };
      #
      #   "element.selected.active" = {
      #     background-color = mkLiteral "@green";
      #   };
      #
      #   "element.normal.urgent" = {
      #     background-color = mkLiteral "@red";
      #   };
      #   "element.alternate.urgent" = {
      #     background-color = mkLiteral "@red";
      #   };
      #
      #   "element.selected.urgent" = {
      #     background-color = mkLiteral "@mauve";
      #   };
      #
      #   element-text = {
      #     size = 40;
      #     margin = mkLiteral "0 10 0 0";
      #     vertical-align = mkLiteral "0.5";
      #     background-color = "inherit";
      #     text-color = mkLiteral "@text";
      #   };
      #
      #   element-icon = {
      #     size = 40;
      #     margin = mkLiteral "0 10 0 0";
      #     vertical-align = mkLiteral "0.5";
      #     background-color = "inherit";
      #     text-color = mkLiteral "@text";
      #   };
      #
      #   "element-text .active" = {
      #     text-color = mkLiteral "@base";
      #   };
      #   "element-text .urgent" = {
      #     text-color = mkLiteral "@base";
      #   };
      # };
    };
  };
}
