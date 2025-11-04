{lib, ...}: {
  options.flake.nilfheim.desktop = with lib; {
    browser = mkOption {
      type = types.str;
      default = "firefox";
      description = "Default web browser command";
    };
    launcher = mkOption {
      type = types.str;
      default = "walker";
      description = "Default app launcher command";
    };
  };
}
