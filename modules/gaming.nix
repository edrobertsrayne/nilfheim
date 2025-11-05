{pkgs, ...}: {
  # System-level: Enable Steam with all features
  flake.modules.nixos.gaming = {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true; # Gamescope for better performance
    };
  };

  # User-level: Lutris and gaming utilities
  flake.modules.homeManager.gaming = {
    home.packages = with pkgs; [
      lutris # Multi-platform game launcher
      gamemode # Performance optimization
      mangohud # FPS overlay
      gamescope # Gaming compositor
      protontricks # Proton prefix management
      wine-staging # Windows compatibility
    ];
  };
}
