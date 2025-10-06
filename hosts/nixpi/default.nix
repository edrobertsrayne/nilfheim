{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  # Set hostname
  networking.hostName = "nixpi";

  # Disable impermanence for SD image
  system.persist.enable = lib.mkForce false;

  # Enable essential services
  services = {
    tailscale.enable = true;
    ssh.enable = true;
    avahi.enable = true;
  };

  # Configure SD image
  sdImage = {
    compressImage = true;
    expandOnBoot = true;
  };

  # Minimal system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
  ];

  # Configure SSH access
  services.openssh = {
    settings = {
      PermitRootLogin = lib.mkForce "yes"; # Allow root login for initial setup
      PasswordAuthentication = false;
    };
  };

  # Configure Tailscale to auto-connect
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = with pkgs; ''
      # Wait for tailscale to be ready
      sleep 5

      # Check if already authenticated
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi

      # Authenticate with tailscale using auth key
      ${tailscale}/bin/tailscale up \
        --authkey=file:${config.age.secrets.tailscale.path} \
        --ssh \
        --accept-routes \
        --hostname=nixpi
    '';
  };

  # Basic network configuration
  networking = {
    useDHCP = lib.mkDefault true;
    interfaces = {};
    firewall = {
      enable = true;
      trustedInterfaces = [config.services.tailscale.interfaceName];
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };
  };

  # Set timezone
  time.timeZone = "Europe/London";

  # Use latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
