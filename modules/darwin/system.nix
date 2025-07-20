{
  pkgs,
  hostname,
  username,
  ...
}: {
  # System-level configuration
  system.stateVersion = 4;
  system.primaryUser = username;

  # Enable nix daemon
  # services.nix-daemon.enable = true;
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
