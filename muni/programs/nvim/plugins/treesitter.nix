{
  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter-context = {
      enable = true;
      mode = "topline";
    };
  };
}
