{
  imports = [
    ./roles/common.nix

    ./services/avahi.nix
    ./services/ssh.nix

    ./system/nix.nix
    ./system/boot.nix

    ./home-manager.nix
    ./user.nix
  ];
}
