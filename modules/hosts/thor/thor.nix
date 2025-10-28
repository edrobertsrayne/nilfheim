{inputs, ...}: {
  flake.modules.nixos.thor = {
    imports = with inputs.self.modules.nixos; [
      ./_disko.nix
      ./_hardware-configuration.nix

      server
    ];

    services.tailscale = {
      extraUpFlags = [
        "--exit-node 10.71.91.83"
        "--exit-node-allow-lan-access=true"
        ''--advertise-routes "192.168.68.0/24"''
      ];
    };
  };
}
