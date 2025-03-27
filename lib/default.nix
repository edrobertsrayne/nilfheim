{lib, ...}:
with lib; rec {
  mkOpt = type: default: description:
    mkOption {inherit type default description;};

  mkOpt' = type: default:
    mkOption {inherit type default;};

  mkBoolOpt = mkOpt types.bool;
  mkBoolOpt' = mkOpt' types.bool;

  enabled = {enable = true;};
  disabled = {enable = false;};

  dashboardServiceType = types.submodule {
    options = {
      group = mkOpt types.str "" "Dashboard group/category";
      name = mkOpt types.str "" "Name of the service";
      entry = mkOpt types.attrs {} "Dashboard entry details";
    };
  };
}
