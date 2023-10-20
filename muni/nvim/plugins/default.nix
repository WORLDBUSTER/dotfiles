{
  config,
  pkgs,
  nvim-dap-vscode-js-src,
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
    ./neorg.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
  ];

  programs.nixvim = {
    plugins.fugitive.enable = true;

    extraPlugins = with pkgs.vimPlugins; let
      nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-dap-vscode-js";
        src = nvim-dap-vscode-js-src;
      };
    in [
      lsp-status-nvim
      nvim-dap-virtual-text
      nvim-dap-vscode-js
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
