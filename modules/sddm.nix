_: {
  flake.modules.nixos.sddm = {
    services.displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      # autoLogin = {
      #   enable = true;
      #   user = "ed";
      # };
    };
    services.xserver.xkb.options = "numlock:on";
  };
}
