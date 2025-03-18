{
  flake = {
    nixosModules = {
      modules = {
        imports = [
          ./desktop/arduino.nix
          ./desktop/firefox.nix
          ./desktop/foot.nix
          ./desktop/gnome.nix
          ./desktop/gtk.nix
          ./desktop/obsidian.nix
          ./desktop/spotify.nix
          ./desktop/virt-manager.nix
          ./desktop/vscode.nix

          ./hardware/audio.nix
          ./hardware/network.nix

          ./services/avahi.nix
          ./services/ssh.nix
          ./services/tailscale.nix

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
      secrets = import ../secrets;
    };
  };
}
