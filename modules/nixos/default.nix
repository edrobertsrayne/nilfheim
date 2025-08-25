{
  imports = [
    ./home-manager.nix

    # Desktop applications and environments
    ./desktop

    # Hardware configuration
    ./hardware

    # Services organized by category
    ./services/backup
    ./services/data
    ./services/downloads
    ./services/media
    ./services/monitoring
    ./services/network
    ./services/security
    ./services/utilities

    # Virtualization and containers
    ./virtualisation

    # Core system configuration
    ./system
  ];

  system.stateVersion = "25.05";
}
