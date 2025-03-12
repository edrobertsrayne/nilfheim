_: let
  mkSecret = name: {
    file = ../../../secrets + "/${name}";
  };
in {
  age.secrets = {
    tailscale = mkSecret "tailscale.age";
  };
}
