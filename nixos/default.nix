{
  flake = {
    nixosModules.modules = {hostname, ...}: {
      imports = [
        ./roles/common.nix
        ./roles/desktop.nix

        ./desktop/firefox.nix
        ./desktop/foot.nix
        ./desktop/gnome.nix
        ./desktop/gtk.nix

        ./services/avahi.nix
        ./services/ssh.nix

        ./system/boot.nix
        ./system/fonts.nix
        ./system/nix.nix
        ./system/persist.nix
        ./system/xkb.nix

        ./home-manager.nix
        ./user.nix
      ];

      networking.hostName = "${hostname}";
      system.stateVersion = "25.05";
    };
  };
}
