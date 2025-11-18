_: {
  flake.modules.nixos.smartd = _: {
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        wall.enable = true;
        test = false;
      };
    };
  };
}
