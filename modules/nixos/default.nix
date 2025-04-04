{
  imports = [
    ./desktop/arduino.nix
    ./desktop/firefox.nix
    ./desktop/foot.nix
    ./desktop/gnome.nix
    ./desktop/gtk.nix
    ./desktop/obsidian.nix
    ./desktop/spotify.nix
    ./desktop/virt-manager.nix
    ./desktop/vscode.nix

    ./hardware/audio.nix
    ./hardware/network.nix

    ./services/avahi.nix
    ./services/bazarr.nix
    ./services/blocky.nix
    ./services/deluge.nix
    ./services/grafana.nix
    ./services/homepage.nix
    ./services/jellyfin.nix
    ./services/jellyseerr.nix
    ./services/lidarr.nix
    ./services/nginx.nix
    ./services/plex.nix
    ./services/prometheus.nix
    ./services/prowlarr.nix
    ./services/radarr.nix
    ./services/readarr.nix
    ./services/sonarr.nix
    ./services/ssh.nix
    ./services/tailscale.nix
    ./services/wireguard-netns.nix

    ./system/boot.nix
    ./system/fonts.nix
    ./system/nix.nix
    ./system/persist.nix
    ./system/xkb.nix

    ./home-manager.nix
    ./user.nix
  ];

  system.stateVersion = "25.05";
}
