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
