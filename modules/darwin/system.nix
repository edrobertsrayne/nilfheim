{
  pkgs,
  hostname,
  username,
  ...
}: {
  # System-level configuration
  system.stateVersion = 6;
  system.primaryUser = username;
  ids.gids.nixbld = 350;

  # Enable nix daemon
  nix.enable = true;

  # Set hostname
  networking.hostName = hostname;

  # Basic system packages
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # User configuration
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # Enable touch ID for sudo
  security.pam.services = {
    sudo_local = {
      reattach = true;
      touchIdAuth = true;
    };
  };
}
