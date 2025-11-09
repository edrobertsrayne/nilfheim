{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      launch-webapp = pkgs.writeShellApplication {
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

      launch-browser = pkgs.writeShellApplication {
        name = "niflheim-launch-browser";
        runtimeInputs = with pkgs; [
          xdg-utils # for xdg-settings
          uwsm # for uwsm-app
          bash
          coreutils # for head, sed
          util-linux # for setsid
        ];
        text = ''
          # Get the default browser desktop file
          default_browser=$(xdg-settings get default-web-browser)

          # Determine private flag based on browser name in desktop file
          if [[ "$default_browser" =~ (firefox|zen|librewolf) ]]; then
            private_flag="--private-window"
          else
            private_flag="--incognito"
          fi

          # Find the desktop file in XDG data directories
          desktop_file=""
          IFS=: read -ra data_dirs <<< "''${XDG_DATA_DIRS:-/usr/share:/usr/local/share}"
          for dir in "''${data_dirs[@]}" "$HOME/.local/share"; do
            if [[ -f "$dir/applications/$default_browser" ]]; then
              desktop_file="$dir/applications/$default_browser"
              break
            fi
          done

          if [[ -z "$desktop_file" ]]; then
            echo "Error: Could not find desktop file: $default_browser" >&2
            exit 1
          fi

          # Extract the Exec line from the desktop file
          browser_exec=$(grep -m 1 "^Exec=" "$desktop_file" | sed 's/^Exec=\([^ ]*\).*/\1/')

          if [[ -z "$browser_exec" ]]; then
            echo "Error: Could not extract Exec from: $desktop_file" >&2
            exit 1
          fi

          # Replace --private with the appropriate flag and launch
          exec setsid uwsm-app -- "$browser_exec" "''${@/--private/$private_flag}"
        '';
      };

      launch-editor = pkgs.writeShellApplication {
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
            exec setsid uwsm-app -- xdg-terminal-exec --app-id=Niflheim -e "$editor_path" "''$@"
            ;;
          *)
            exec setsid uwsm-app -- "$editor_path" "''$@"
            ;;
          esac
        '';
      };

      launch-presentation-terminal = pkgs.writeShellApplication {
        name = "launch-presentation-terminal";
        runtimeInputs = with pkgs; [
          uwsm
          util-linux
          inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.show-done
          inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.show-logo
        ];
        text = ''
          cmd="$*"
          exec setsid uwsm-app -- xdg-terminal-exec --app-id=Niflheim --title=Niflheim -- bash -c "show-logo; $cmd; show-done"
        '';
      };

      show-logo = pkgs.writeShellApplication {
        name = "show-logo";
        runtimeInputs = with pkgs; [
          lolcat
          figlet
        ];
        text = ''
          figlet -f doom "niflheim" | lolcat
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
