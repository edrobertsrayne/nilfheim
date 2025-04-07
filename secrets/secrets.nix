let
  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJFqOIXL2rj72/1lXfy4QRM1a+MmRzdQbK0NUpDL/z1";
  freya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIO4RjgGmeN0QCTS8V5raJwcoxajuh2K60jtAhw2El1";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4jHnG95Nwr9cauhLD5Aq1PcGk0s9mqfL0YJs/N2fJh";
  systems = [freya odin thor];
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdf/364Rgul97UR6vn4caDuuxBk9fUrRjfpMsa4sfam ed@freya"
  ];
in {
  "tailscale.age".publicKeys = systems ++ users;
  "mullvad.age".publicKeys = systems ++ users;
  "homepage.age".publicKeys = systems ++ users;
  "autobrr.age".publicKeys = systems ++ users;
}
