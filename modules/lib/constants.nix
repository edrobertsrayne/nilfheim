_: {
  flake.lib.constants = let
    ports = {
      portainer = 9443;
      portainer-http = 9002;
      portainer-agent = 9001;
    };
  in {
    inherit ports;
  };
}
