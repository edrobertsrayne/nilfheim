_: {
  flake.modules.darwin.darwin = {
    homebrew = {
      enable = true;
      taps = [
        "homebrew/cask-fonts"
      ];

      brews = [
      ];

      casks = [
        "adobe-connect"
        "adobe-creative-cloud"
        "alacritty"
        "arduino-ide"
        "balenaetcher"
        "bambu-studio"
        "claude"
        "docker-desktop"
        "firefox"
        "ghostty"
        "github"
        "google-chrome"
        "google-drive"
        "kicad"
        "kitty"
        "microsoft-edge"
        "moonlight"
        "processing"
        "raycast"
        "steam"
        "tailscale-app"
        "utm"
        "visual-studio-code"
        "vlc"
        "wezterm"
      ];
      onActivation.cleanup = "uninstall";
    };
  };
}
