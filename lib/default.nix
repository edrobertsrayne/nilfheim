{lib, ...}:
with lib; rec {
  mkOpt = type: default: description:
    mkOption {inherit type default description;};
  enabled = {enable = true;};
  disabled = {enable = false;};
}
