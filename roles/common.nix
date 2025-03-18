{
  lib,
  pkgs,
  ...
}:
with lib.custom; {
  modules = {
    hardware.network = enabled;
    services = {
      avahi = enabled;
      ssh = enabled;
      tailscale = enabled;
    };
    system = {
      boot = enabled;
      nix = enabled;
      persist = enabled;
    };
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];
}
