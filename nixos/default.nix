{
  imports = [
    ./roles/common.nix
    ./roles/desktop.nix

    ./desktop/firefox.nix
    ./desktop/foot.nix
    ./desktop/gnome.nix
    ./desktop/gtk.nix

    ./services/avahi.nix
    ./services/ssh.nix

    ./system/nix.nix
    ./system/fonts.nix
    ./system/boot.nix
    ./system/xkb.nix

    ./home-manager.nix
    ./user.nix
  ];
}
