{ pkgs, ... }:

{
  enable = true;
  package = pkgs.neovim-nightly;

  extraConfig = builtins.readFile ./init.vim;
  extraPackages = with pkgs; [
    tree-sitter
  ];
  plugins = with pkgs.vimPlugins; [
    FixCursorHold-nvim
    cmp-buffer
    cmp-calc
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path
    cmp-vsnip
    direnv-vim
    friendly-snippets
    hop-nvim
    lsp-status-nvim
    nvim-cmp
    nvim-lspconfig
    plenary-nvim
    popup-nvim
    vim-commentary
    vim-fugitive
    vim-pandoc
    vim-pandoc-syntax
    vim-smoothie
    vim-surround
    vim-table-mode
    vim-vsnip
    vim-vsnip-integ

    {
      plugin = emmet-vim;
      config = "let g:user_emmet_leader_key = '<leader>a'";
    }
    {
      plugin = neorg;
      config = ''
        lua << EOF
          require('neorg').setup {
              load = {
                  ["core.defaults"] = {}, -- Load all the default modules
                  ["core.norg.concealer"] = {}, -- Allows for use of icons
                  ["core.norg.dirman"] = { -- Manage your directories with Neorg
                      config = {
                          workspaces = {
                              notebook = "~/notebook"
                          }
                      }
                  },
                  ["core.norg.completion"] = {
                      config = {
                          engine = "nvim-cmp"
                      }
                  }
              }
          }
          EOF
      '';
    }
    {
      plugin = telescope-nvim;
      config = ''
        lua << EOF
          local actions = require('telescope.actions')
          require('telescope').setup{
              defaults = {
                  mappings = {
                      i = {
                          ["<esc>"] = actions.close
                      },
                  },
              }
          }
        EOF
      '';
    }
    {
      plugin = nvim-treesitter;
      config = ''
        lua << EOF
          -- sets up treesitter with neorg
          local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

          parser_configs.norg = {
              install_info = {
                  url = "https://github.com/nvim-neorg/tree-sitter-norg",
                  files = { "src/parser.c", "src/scanner.cc" },
                  branch = "main"
              },
          }

          -- set up treesitter
          require'nvim-treesitter.configs'.setup {
              ensure_installed = "all",
              highlight = {
                  enable = true,
              },
          }
        EOF
      '';
    }
    {
      plugin = vim-gitgutter;
      config = "
        let g:gitgutter_map_keys = 0
        let g:gitgutter_sign_allow_clobber = 0
      ";
    }
    {
      plugin = vim-polyglot;
      config = "let g:polyglot_disabled = ['markdown.plugin', 'pandoc.plugin', 'rust.plugin', 'typescript.plugin', 'javascript.plugin', 'html.plugin', 'css.plugin', 'scss.plugin', 'yaml.plugin', 'vim.plugin']";
    }
    {
      plugin = vim-startify;
      config = "
        let g:startify_custom_header = startify#fortune#cowsay('', '═','║','╔','╗','╝','╚')
        let g:startify_lists = [
          \\ { 'type': 'sessions',  'header': ['   Sessions']             },
          \\ { 'type': 'dir',       'header': ['   Recent in '. getcwd()] },
          \\ { 'type': 'files',     'header': ['   Recent']               },
          \\ { 'type': 'bookmarks', 'header': ['   Bookmarks']            },
          \\ { 'type': 'commands',  'header': ['   Commands']             },
          \\ ]
        let g:startify_session_persistence = 1
      ";
    }
    {
      plugin = vim-table-mode;
      config = "
        let g:table_mode_corner = '+'
        let g:table_mode_corner_corner = '+'
        let g:table_mode_header_fillchar = '='
      ";
    }
  ];
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  withPython3 = true;
  withRuby = true;
}
