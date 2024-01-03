{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cmp.nix
    ./copilot.nix
    ./dap.nix
    ./emmet.nix
    ./floaterm.nix
    ./gitsigns.nix
    ./lsp.nix
    ./lspkind.nix
    ./mini
    ./none-ls.nix
    ./neorg.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
    ./vscode-js-debug.nix
  ];

  programs.nixvim = {
    plugins = {
      auto-save.enable = true;
      fugitive.enable = true;
      undotree.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      lsp-status-nvim
      nvim-snippy
      nvim-web-devicons
      playground
      plenary-nvim
      popup-nvim
      twilight-nvim
      vim-hexokinase
      zen-mode-nvim
    ];
  };
}
