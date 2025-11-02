_: {
  flake.modules.home.hyprland = {lib, ...}: {
    programs.hyprlock = {
      enable = true;
      # TODO: get the background image from waypaper and use on lock screen
      settings = {
        background = lib.mkForce [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
      };
    };
  };
}
