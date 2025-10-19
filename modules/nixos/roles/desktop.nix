{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.roles.desktop;
  inherit (config) user;
in {
  options.roles.desktop = {
    enable = mkEnableOption "desktop role";
  };

  config = mkIf cfg.enable {
    # Auto-enable common role
    roles.common.enable = true;

    nixpkgs.config.allowUnfree = true;

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      fonts.monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };

    desktop = {
      hyprland.enable = true;

      fonts.enable = true;
      gtk.enable = true;
      xkb.enable = true;
    };

    home-manager = {
      enable = true;
      users.${user.name} = {
        desktop = {
          foot.enable = true;
          waybar.enable = true;
          walker.enable = true;
          rofi.enable = true;
          wlogout.enable = true;
          zathura.enable = true;
          swaync.enable = true;
        };
        programs = {
          alacritty.enable = true;
          wezterm.enable = true;
          kitty.enable = true;
          ghostty.enable = true;
        };
        # Virt-Manager connection settings
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      };
    };

    hardware = {
      audio.enable = true;
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
      firefox.enable = true;
      virt-manager.enable = true;
    };

    virtualisation.libvirt.enable = true;

    security.polkit.enable = true;

    # Set Firefox as default browser
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };

    # Spotify firewall ports
    networking.firewall = {
      allowedTCPPorts = [57621];
      allowedUDPPorts = [5353];
    };

    services = {
      blueman.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
          autoSuspend = true;
        };
      };
      power-profiles-daemon.enable = false;
    };

    services.nfs-client = {
      enable = true;
      server = "thor";
      mounts = {
        downloads = {
          remotePath = "/downloads";
          localPath = "/mnt/downloads";
        };
        media = {
          remotePath = "/media";
          localPath = "/mnt/media";
          options = ["soft" "intr" "bg" "vers=4" "ro"];
        };
        backup = {
          remotePath = "/backup";
          localPath = "/mnt/backup";
        };
        share = {
          remotePath = "/share";
          localPath = "/mnt/share";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      processing
      vlc
      # kicad
      # bambu-studio

      # Desktop applications
      arduino-ide
      discord
      firefox
      gimp
      inkscape
      obsidian
      spotify
      vscode
      zathura

      # LaTeX support
      texlive.combined.scheme-medium

      # Gaming applications
      mangohud
      protonup-qt
      lutris
      bottles
      heroic
      moonlight-qt

      # System utilities
      brightnessctl
      playerctl
      pamixer
      cliphist
      networkmanagerapplet
      pavucontrol
      nautilus
    ];
  };
}
