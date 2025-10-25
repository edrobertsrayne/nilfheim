_: {
  flake.modules.homeManager.nixvim = {
    programs.nixvim.opts = {
      breakindent = true;
      completeopt = "menu,menuone,noselect";
      confirm = true;
      cursorline = true;
      expandtab = true;
      foldlevel = 99;
      foldlevelstart = 99;
      foldcolumn = "1";
      hlsearch = true;
      ignorecase = true;
      inccommand = "split";
      laststatus = 3;
      list = true;
      mouse = "a";
      number = true;
      relativenumber = true;
      ruler = false;
      scrolloff = 10;
      shiftround = true;
      shiftwidth = 2;
      showmode = false;
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      splitbelow = true;
      splitright = true;
      timeoutlen = 300;
      undofile = true;
      undolevels = 10000;
      updatetime = 200;
      wrap = false;
    };
  };
}
