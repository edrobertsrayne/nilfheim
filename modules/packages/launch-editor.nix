{
  perSystem = {pkgs, ...}: {
    packages.launch-editor = pkgs.writeShellApplication {
      name = "launch-editor";
      runtimeInputs = with pkgs; [
        uwsm
        util-linux
      ];
      text = ''
        editor_path=$(command -v "''${EDITOR:-nvim}") || {
          echo "Error: Editor ''${EDITOR:-nvim} not found" >&2
          exit 1
        }
        editor_name=$(basename "$editor_path")
        case "$editor_name" in
        nvim | vim | nano | micro | hx | helix)
          exec setsid uwsm-app -- "''${TERMINAL:-alacritty}" -e "$editor_path" "''$@"
          ;;
        *)
          exec setsid uwsm-app -- "$editor_path" "''$@"
          ;;
        esac
      '';
    };
  };
}
