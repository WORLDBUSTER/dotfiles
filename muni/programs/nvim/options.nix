{
  programs.nixvim.opts = {
    autoread = true;
    autowriteall = true;
    background = "dark";
    clipboard = "unnamedplus";
    cmdheight = 2;
    complete = ".,w,b,u,t,kspell"; # spell check
    conceallevel = 2;
    diffopt = "hiddenoff,iwhiteall,closeoff,internal,filler,indent-heuristic,linematch:60";
    equalalways = true;
    errorbells = false;
    expandtab = true;
    fillchars = "fold:~,stl: ,stlnc: ";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldlevelstart = 5;
    foldmethod = "expr";
    hidden = true;
    lazyredraw = true;
    listchars = "tab:> ,trail:·";
    pumheight = 20;
    pumwidth = 80;
    relativenumber = true;
    scrolloff = 5;
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
    shiftwidth = 4;
    showmode = false;
    softtabstop = 4;
    swapfile = false;
    tabline = "%!TabLine()";
    tabstop = 4;
    tags = "./tags;";
    termguicolors = true;
    textwidth = 80;
    timeoutlen = 500;
    title = false;
    undolevels = 100;
    undoreload = 1000;
    updatetime = 300;
    visualbell = false;
    whichwrap = "<,>,h,l";
    wildignore = "*/node_modules,*/node_modules/*,.git,.git/*,tags,*/dist,*/dist/*";
    wrap = true;
  };
}
