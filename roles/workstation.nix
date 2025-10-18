{
  pkgs,
  config,
  ...
}: let
  inherit (config) user;
in {
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
      programs = {
        alacritty.enable = true;
        wezterm.enable = true;
        kitty.enable = true;
        ghostty.enable = true;
      };
    };
  };

  hardware = {
    audio.enable = true;
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
  };

  services = {
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
    discord
    gimp
    inkscape
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
  ];
}
