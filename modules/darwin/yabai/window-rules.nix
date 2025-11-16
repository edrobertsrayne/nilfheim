_: {
  flake.modules.darwin.yabai = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.yabai;
  in {
    config = lib.mkIf cfg.enable {
      services.yabai.extraConfig = ''
        # System applications - never tile
        yabai -m rule --add app="^System Settings$" manage=off
        yabai -m rule --add app="^System Preferences$" manage=off # Older macOS versions
        yabai -m rule --add app="^System Information$" manage=off
        yabai -m rule --add app="^Activity Monitor$" manage=off
        yabai -m rule --add app="^Console$" manage=off
        yabai -m rule --add app="^Disk Utility$" manage=off

        # Finder and file operations
        yabai -m rule --add app="^Finder$" manage=off
        yabai -m rule --add app="^Archive Utility$" manage=off
        yabai -m rule --add app="^Installer$" manage=off
        yabai -m rule --add app="^App Store$" manage=off

        # Utilities
        yabai -m rule --add app="^Calculator$" manage=off
        yabai -m rule --add app="^Dictionary$" manage=off
        yabai -m rule --add app="^QuickTime Player$" manage=off
        yabai -m rule --add app="^Preview$" manage=off

        # Launchers and menu bar apps
        yabai -m rule --add app="^Raycast$" manage=off
        yabai -m rule --add app="^Alfred$" manage=off
        yabai -m rule --add app="^Spotlight$" manage=off

        # Security and VPN
        yabai -m rule --add app="^Tailscale$" manage=off
        yabai -m rule --add app="^1Password$" manage=off
        yabai -m rule --add app="^Bitwarden$" manage=off

        # Development tools that should float
        yabai -m rule --add app="^Docker Desktop$" manage=off
        yabai -m rule --add app="^Adobe Creative Cloud$" manage=off

        # Virtualization
        yabai -m rule --add app="^UTM$" manage=off
        yabai -m rule --add app="^VirtualBox$" manage=off

        # Media applications (optional - some prefer tiled)
        # Uncomment if you prefer these to float:
        # yabai -m rule --add app="^VLC$" manage=off
        # yabai -m rule --add app="^IINA$" manage=off
        # yabai -m rule --add app="^QuickTime Player$" manage=off

        # Generic patterns for dialogs and preferences
        yabai -m rule --add title="^(Open|Save|Choose).*" manage=off
        yabai -m rule --add title="Preferences$" manage=off
        yabai -m rule --add title="Settings$" manage=off

        # Picture-in-Picture (float and keep above other windows)
        yabai -m rule --add title="^Picture-in-Picture$" manage=off

        # Software updates and installers
        yabai -m rule --add app="^Software Update$" manage=off
        yabai -m rule --add title="Install.*" manage=off
        yabai -m rule --add title="Update.*" manage=off
      '';
    };
  };
}
