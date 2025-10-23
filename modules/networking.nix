{
  flake.modules.nixos.networking = { lib, ... }: {
    # Enable networking
    networking.networkmanager.enable = true;

    # Enable SSH for remote access
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        PasswordAuthentication = lib.mkDefault true;
      };
    };

    # Open firewall for SSH
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
