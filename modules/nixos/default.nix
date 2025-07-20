{
  imports = [
    ./desktop/arduino.nix
    ./desktop/firefox.nix
    ./desktop/fonts.nix
    ./desktop/foot.nix
    ./desktop/gnome.nix
    ./desktop/gtk.nix
    ./desktop/obsidian.nix
    ./desktop/spotify.nix
    ./desktop/virt-manager.nix
    ./desktop/vscode.nix
    ./desktop/xkb.nix

    ./hardware/audio.nix
    ./hardware/network.nix

    ./services/avahi.nix
    ./services/audiobookshelf.nix
    ./services/autobrr.nix
    ./services/bazarr.nix
    ./services/blocky.nix
    ./services/deluge.nix
    ./services/glances.nix
    ./services/grafana.nix
    ./services/homepage.nix
    ./services/jellyfin.nix
    ./services/jellyseerr.nix
    ./services/kavita.nix
    ./services/lidarr.nix
    ./services/nginx.nix
    ./services/plex.nix
    ./services/prometheus.nix
    ./services/prowlarr.nix
    ./services/proxmox-ve.nix
    ./services/radarr.nix
    ./services/readarr.nix
    ./services/sabnzbd.nix
    ./services/samba.nix
    ./services/sonarr.nix
    ./services/ssh.nix
    ./services/stirling-pdf.nix
    ./services/transmission.nix
    ./services/tailscale.nix
    ./services/uptime-kuma.nix

    ./virtualisation/homeassistant.nix
    ./virtualisation/podman.nix
    ./virtualisation/tdarr.nix

    ./system/boot.nix
    ./system/nix.nix
    ./system/persist.nix
    ./system/user.nix
  ];

  system.stateVersion = "25.05";
}
