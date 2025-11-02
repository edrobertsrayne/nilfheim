{
  flake.modules.nixos.nixos = {
    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowPing = true;
      };
    };
  };
}
