let
  freya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3SNrlpGasU1b0I3e6ynmqeuWKeT8gZjVAjKZxHMXaG";
  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJFqOIXL2rj72/1lXfy4QRM1a+MmRzdQbK0NUpDL/z1";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkIYQ9LaTuLo7cuK/ZbdmSi8F+W6zRcxv9zwQ7kc8Lc";
  systems = [freya loki odin];
in {
  "tailscale.age".publicKeys = systems;
}
