_: {
  flake.modules.homeManager.alacritty = _: {
    programs.alacritty = {
      enable = true;
      settings = {
        env = {TERM = "xterm-256color";};
        window = {
          padding = {
            x = 14;
            y = 14;
          };
          decorations = "None";
        };
        keyboard.bindings = [
          {
            key = "Insert";
            mods = "Shift";
            action = "Paste";
          }
          {
            key = "Insert";
            mods = "Control";
            action = "Copy";
          }
        ];
      };
    };
  };
}
