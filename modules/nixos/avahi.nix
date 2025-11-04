_: {
  flake.modules.nixos.nixos = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        workstation = true;
        userServices = true;
      };
    };
  };
}
