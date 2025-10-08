{
  pkgs,
  config,
  ...
}: let
  inherit (config) user;
in {
  nixpkgs.config.allowUnfree = true;

  # Enable power management for workstations (especially laptops)
  powerManagement.enable = true;

  catppuccin = {
    flavor = "mocha";
    enable = true;
  };

  desktop = {
    # Desktop Environments
    gnome.enable = true;
    hyprland.enable = true;

    arduino.enable = true;
    foot.enable = true;
    firefox.enable = true;
    obsidian.enable = true;
    spotify.enable = true;
    virtManager.enable = true;
    vscode.enable = true;

    fonts.enable = true;
    xkb.enable = true;
  };

  home-manager = {
    enable = true;
    users.${user.name}.config = {
      catppuccin = {
        flavor = "mocha";
        enable = true;
      };
      programs = {
        alacritty.enable = true;
        wezterm.enable = true;
        kitty.enable = true;
        ghostty.enable = true;
      };
    };
  };

  hardware.audio.enable = true;

  # Display manager - shared between GNOME and Hyprland
  services = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = true;
      };
    };
  };

  # Configure NFS client to mount thor's shared storage
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
    bambu-studio

    # Desktop applications
    discord
    gimp
    inkscape
    zathura

    # LaTeX support
    texlive.combined.scheme-medium
  ];
}
