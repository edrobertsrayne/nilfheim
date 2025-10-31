{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      launch-presentation-terminal = pkgs.writeShellApplication {
        name = "launch-presentation-terminal";
        runtimeInputs = with pkgs; [
          uwsm
          util-linux
          inputs.self.packages.${pkgs.system}.show-done
          inputs.self.packages.${pkgs.system}.show-logo
        ];
        text = ''
          cmd="$*"
          exec setsid uwsm-app -- "''${TERMINAL:-alacritty}" --class=Nilfheim --title=Nilfheim -e bash -c "show-logo; $cmd; show-done"
        '';
      };
      show-logo = pkgs.writeShellApplication {
        name = "show-logo";
        runtimeInputs = with pkgs; [
          lolcat
          figlet
        ];
        text = ''
          figlet -f doom "nilfheim" | lolcat
        '';
      };
      show-done = pkgs.writeShellApplication {
        name = "show-done";
        runtimeInputs = with pkgs; [
          gum
        ];
        text = ''
          echo
          gum spin --title "Done! Press any key to close..." -- bash -c 'read -n 1 -s'
        '';
      };
    };
  };
}
