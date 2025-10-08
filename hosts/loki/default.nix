{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
  ];

  networking.firewall.allowedTCPPorts = [80 443 3000 8080];
  networking.firewall.allowedUDPPorts = [443];
  system.persist.extraRootDirectories = ["/etc/dokploy" "/var/lib/docker" "/srv/docker"];
}
