{pkgs, ...}: {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable SSH with your public key
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; # Disable root login for security
      PasswordAuthentication = false; # Disable password authentication
    };
  };

  # Add your SSH public key to the default user
  # Enable QEMU guest agent (optional but recommended)
  services.qemuGuest.enable = true;

  # Set the time zone
  time.timeZone = "UTC";

  # Enable flakes and the new Nix CLI
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # System packages (optional)
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];

  # Enable garbage collection to save disk space
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
