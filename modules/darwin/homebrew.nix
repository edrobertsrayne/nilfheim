{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [
      "homebrew/cask-fonts"
    ];

    brews = [
      # Add any CLI tools you need from homebrew
    ];

    casks = [
      # Add GUI applications here
      # Example: "firefox"
    ];
  };
}
