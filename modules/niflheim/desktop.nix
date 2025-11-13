{lib, ...}: {
  options.flake.niflheim.desktop = with lib; {
    browser = mkOption {
      type = types.str;
      default = "google-chrome";
      description = "Default web browser command";
    };
    launcher = mkOption {
      type = types.str;
      default = "walker";
      description = "Default app launcher command";
    };
  };
}
