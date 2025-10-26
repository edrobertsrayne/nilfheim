_: {
  flake.lib.nixvim = let
    mkKeymap = mode: key: action: desc: {
      inherit mode key action;
      options = {
        inherit desc;
        silent = true;
      };
    };

    mkLuaKeymap = mode: key: luaFn: desc: {
      inherit mode key;
      action.__raw = luaFn;
      options = {
        inherit desc;
        silent = true;
      };
    };
  in {
    inherit mkKeymap mkLuaKeymap;
  };
}
