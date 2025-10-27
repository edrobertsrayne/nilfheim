let
  app = pkgs:
    pkgs.writeShellApplication {
      name = "launch-webapp";
      runtimeInputs = with pkgs; [
        uwsm # for uwsm-app
        bash
        util-linux # for setsid
      ];
      text = ''
        # Launch the browser in app mode with the URL and any additional arguments
        exec setsid uwsm-app -- ${pkgs.chromium}/bin/chromium --app="$1" "''${@:2}"
      '';
    };
in {
  perSystem = {pkgs, ...}: {
    packages.launch-webapp = app pkgs;
  };
}
