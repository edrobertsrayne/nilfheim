{lib, ...}: {
  options.flake.nilfheim.desktop = with lib; {
    terminal = mkOption {
      type = types.str;
      default = "alacritty";
      description = "Default terminal emulator command";
    };
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
