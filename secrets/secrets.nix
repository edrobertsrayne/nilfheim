let
  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJFqOIXL2rj72/1lXfy4QRM1a+MmRzdQbK0NUpDL/z1";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmanxD3yVEHjRsz2ZNOL7l5skXX3ytrm/uYO9PHNF+Y";
  freya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIO4RjgGmeN0QCTS8V5raJwcoxajuh2K60jtAhw2El1";
  systems = [freya loki odin];
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdf/364Rgul97UR6vn4caDuuxBk9fUrRjfpMsa4sfam ed@freya"
  ];
in {
  "tailscale.age".publicKeys = systems ++ users;
  "mullvad.age".publicKeys = systems ++ users;
  "servarr.age".publicKeys = systems ++ users;
  "homepage.age".publicKeys = systems ++ users;
}
