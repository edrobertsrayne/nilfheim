{
  pkgs,
  config,
  ...
}: let
  inherit (config) user;
in {
  nixpkgs.config.allowUnfree = true;

  catppuccin = {
    flavor = "mocha";
    enable = true;
  };

  desktop = {
    gnome.enable = true;

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
      };
    };
  };

  hardware.audio.enable = true;

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
  ];
}
