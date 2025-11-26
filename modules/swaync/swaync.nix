_: {
  flake.modules.homeManager.swaync = {config, ...}: {
    # TODO: fix notification icons and MPRIS album art
    # TODO: add wireless, bluetooth and other relevant buttons
    stylix.targets.swaync.enable = false;

    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER, N, Toggle notification centre, exec, swaync-client -t -sw"
    ];

    services.swaync = {
      enable = true;
      settings = {
        widgets = ["title" "notifications" "mpris" "volume"];
        image-visibility = "when-available";
        mpris = {
          image-visibility = "when-available";
          image-size = 96;
        };
      };
      style = with config.lib.stylix.colors.withHashtag;
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01};
          @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05};
          @define-color base06 ${base06}; @define-color base07 ${base07};
          @define-color base08 ${base08}; @define-color base09 ${base09};
          @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D};
          @define-color base0E ${base0E}; @define-color base0F ${base0F};

          * {
            font-family: "${config.stylix.fonts.monospace.name}";
            font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
            all: unset;
            transition: 200ms;
          }
        ''
        + (builtins.readFile ./style.css);
    };
  };
}
