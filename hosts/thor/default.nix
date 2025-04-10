{username, ...}: {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  # Ensure ZFS is set up properly
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["tank"];

  # Create tank group and add main user
  users.groups.tank.members = ["${username}"];

  # Configure tank mountpoints
  systemd.tmpfiles.rules = [
    "d /mnt/downloads 2775 root tank"
    "d /mnt/media 2775 root tank"
    "d /mnt/backup 2775 root tank"
    "d /mnt/share 2775 root tank"
  ];
}
