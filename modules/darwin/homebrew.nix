{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

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
      "github"
      "google-chrome"
      "google-drive"
      "karabiner-elements"
      "kicad"
      "processing"
      "raycast"
      "steam"
      "tailscale"
      "tailscale-app"
      "utm"
      "visual-studio-code"
      "vlc"
      "wezterm"
    ];
  };
}
