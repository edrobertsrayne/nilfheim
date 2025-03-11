{namespace, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
    (import ./disko.nix {device = "/dev/nvme0n1";})
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ${namespace}.suites = {
    common.enable = true;
    desktop.enable = true;
  };

  networking.hostName = "freya";

  system.stateVersion = "25.05"; # Did you read the comment?
}
