{namespace, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
    (import ./disko.nix {device = "/dev/nvme0n1";})
  ];

  ${namespace} = {
    persist.enable = true;
    suites = {
      common.enable = true;
      desktop.enable = true;
    };
  };

  networking.hostName = "freya";

  system.stateVersion = "25.05"; # Did you read the comment?
}
