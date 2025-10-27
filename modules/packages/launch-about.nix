let
  app = pkgs:
    pkgs.writeShellApplication {
      name = "launch-about";
      runtimeInputs = with pkgs; [
        uwsm
        bash
        util-linux
        fastfetch
      ];
      text = ''
        exec setsid uwsm-app -- "''${TERMINAL:-alacritty}" --class=Nilfheim -o font.size=12 -e bash -c 'fastfetch; read -n 1 -s'
      '';
    };
in {
  perSystem = {pkgs, ...}: {
    packages.launch-about = app pkgs;
  };
}
