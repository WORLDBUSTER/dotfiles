{
  config,
  pkgs,
  nvim-dap-vscode-js-src,
  ...
}: let
  nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-dap-vscode-js";
    src = nvim-dap-vscode-js-src;
  };
in {
  imports = [
    ./fnl.nix
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    defaultEditor = true;

    extraConfig = builtins.readFile ./init.vim;
    extraFnlConfigFiles = [
      ./fnl/lsp.fnl
      ./fnl/statusline.fnl
      ./fnl/keys.fnl
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = indent-blankline-nvim;
        config = builtins.readFile ./fnl/config/indent-blankline.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-cmp;
        config = builtins.readFile ./fnl/config/cmp.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-dap;
        config = builtins.readFile ./fnl/config/dap.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-tree-lua;
        config = builtins.readFile ./fnl/config/nvim-tree.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-web-devicons;
        config = builtins.readFile ./fnl/config/devicons.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        config = builtins.readFile ./fnl/config/treesitter.fnl;
        type = "fennel";
      }
      {
        plugin = which-key-nvim;
        config = builtins.readFile ./fnl/config/which-key.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-dap-vscode-js;
        config = ''
          require("dap-vscode-js").setup({
            debugger_path = "/home/muni/.config/nvim/vscode-js-debug/dist/",
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
          })

          for _, language in ipairs({ "typescript", "javascript" }) do
            require("dap").configurations[language] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "''${file}",
                cwd = "''${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require'dap.utils'.pick_process,
                cwd = "''${workspaceFolder}",
              }
            }
          end
        '';
        type = "lua";
      }
      {
        plugin = nvim-treesitter-context;
        config = builtins.readFile ./fnl/config/context.fnl;
        type = "fennel";
      }
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  xdg.configFile = {
    "nvim/pandoc-preview.sh" = {
      executable = true;
      source = ./pandoc-preview.sh;
    };
  };
}
