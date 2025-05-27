{pkgs, ...}: {
  hardware.network.enable = true;
  virtualisation.podman.enable = true;
  services = {
    avahi.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
  };
  system = {
    boot.enable = true;
    nix.enable = true;
    persist.enable = true;
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];
}
