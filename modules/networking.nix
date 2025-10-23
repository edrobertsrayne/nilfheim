{
  flake.modules.nixos.networking = {lib, ...}: {
    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowPing = true;
      };
    };
  };
}
