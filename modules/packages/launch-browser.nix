let
  app = pkgs:
    pkgs.writeShellApplication {
      name = "nilfheim-launch-browser";
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
in {
  perSystem = {pkgs, ...}: {
    packages.nilfheim-launch-browser = app pkgs;
  };
}
