{
  pkgs,
  hostname,
  username,
  ...
}: {
  ids.gids.nixbld = 350;

  nix = {
    enable = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@admin"];
      extra-platforms = ["x86_64-linux" "aarch64-linux"];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };
  };

  networking.hostName = hostname;

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system = {
    stateVersion = 6; # DO NOT CHANGE!
    primaryUser = username;
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
        tilesize = 24;
        magnification = false;
        show-recents = false;
        launchanim = false;
        show-process-indicators = true;
        mineffect = "scale";
      };
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        _FXShowPosixPathInTitle = true;
        QuitMenuItem = true;
      };
      NSGlobalDomain = {
        _HIHideMenuBar = false;
        AppleKeyboardUIMode = 3;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        AppleInterfaceStyle = "Dark";
      };
      screencapture = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
    };
  };

  security.pam.services = {
    sudo_local = {
      reattach = true;
      touchIdAuth = true;
    };
  };
}
