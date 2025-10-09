{pkgs, ...}: {
  hardware.network.enable = true;

  virtualisation.docker.enable = true;

  services = {
    avahi.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
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
