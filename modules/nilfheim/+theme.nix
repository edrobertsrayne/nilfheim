{lib, ...}: {
  options.flake.nilfheim.theme = with lib; {
    base16 = mkOption {
      type = types.str;
      default = "tokyo-night-dark";
    };
  };
}
