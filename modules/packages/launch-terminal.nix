let
  app = pkgs:
    pkgs.writeShellApplication {
      name = "launch-terminal";
      runtimeInputs = with pkgs; [
        uwsm
        bash
        util-linux
      ];
      text = ''
        exec setsid uwsm-app -- "''${TERMINAL:-alacritty}" "''$@"
      '';
    };
in {
  perSystem = {pkgs, ...}: {
    packages.launch-terminal = app pkgs;
  };
}
