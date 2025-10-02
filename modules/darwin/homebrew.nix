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
      "microsoft-edge"
      "moonlight"
      "processing"
      "raycast"
      "steam"
      "tailscale-app"
      "utm"
      "visual-studio-code"
      "vlc"
    ];
  };
}
