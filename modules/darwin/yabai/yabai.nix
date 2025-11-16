_: {
  flake.modules.darwin.yabai = {
    pkgs,
    lib,
    ...
  }: {
    # Enable yabai window manager (SIP-compatible mode)
    services.yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = false; # Must be false with SIP enabled
    };

    # Additional system configuration for yabai
    # Ensure required packages are available
    environment.systemPackages = with pkgs; [
      yabai
      skhd
      jq # Used in skhd keybinds for layout toggling
    ];

    # Configure launchd service to start at login
    # Note: nix-darwin's services.yabai automatically handles this,
    # but we ensure proper permissions and settings here
    system.activationScripts.postActivation.text = lib.mkAfter ''
      # Ensure yabai has proper permissions
      # Note: With SIP enabled, no additional setup is needed
      # If you disable SIP in the future, run: sudo yabai --install-sa
      echo "yabai configured for SIP-enabled mode"
      echo "To enable full features (opacity, window focus, etc.):"
      echo "  1. Disable SIP in Recovery Mode"
      echo "  2. Set services.yabai.enableScriptingAddition = true"
      echo "  3. Run: sudo yabai --install-sa"
      echo "  4. Restart yabai service"
    '';
  };
}
