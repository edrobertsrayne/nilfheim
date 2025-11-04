_: {
  flake.modules.nixos.capslock-remap = {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings.main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };
}
