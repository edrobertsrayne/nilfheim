{
  flake = {
    nixosModules.modules = {
      imports = [
        ./roles/common.nix
        ./roles/desktop.nix

        ./desktop/firefox.nix
        ./desktop/foot.nix
        ./desktop/gnome.nix
        ./desktop/gtk.nix

        ./hardware/audio.nix
        ./hardware/network.nix

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

      system.stateVersion = "25.05";
    };
  };
}
