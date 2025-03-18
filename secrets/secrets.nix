let
  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJFqOIXL2rj72/1lXfy4QRM1a+MmRzdQbK0NUpDL/z1";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3mLwuioaT6TJf0+xi6hxhj6ATR7CEN6+ehX/q/1Fcv";
  freya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3SNrlpGasU1b0I3e6ynmqeuWKeT8gZjVAjKZxHMXaG";
  systems = [freya loki odin];
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjO/+Q0fcuPJlilQNFfTbxG78ov3owvJW66poCTZVy4 
"
  ];
in {
  "tailscale.age".publicKeys = systems ++ users;
}
