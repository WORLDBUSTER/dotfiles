(let [g (fn [key value]
          (tset vim.g key value))
      o (fn [key value]
          (tset vim.o key value))
      bo (fn [key value]
           (tset vim.bo key value))
      wo (fn [key value]
           (tset vim.wo key value))]
  (g :mapleader ",")
  ;; plugin config
  (g :coq_settings {:auto_start :shut-up
                    :clients {:paths {:resolution [:file]
                                      :short_name :path}
                              :buffers {:short_name :buf}
                              :lsp {:short_name :lsp}
                              :snippets {:short_name :snip}
                              :tree_sitter {:short_name :ts}
                              :tmux {:short_name :tmux}
                              :third_party {:short_name :3rd}}
                    :display {:ghost_text {:context [" 〉" ""]}
                              :pum {:fast_close false
                                    :y_ratio 0.3
                                    :x_max_len 60
                                    :kind_context ["  " ""]
                                    :source_context [" " ""]}
                              :icons {:mappings {:Boolean " "
                                                 :Character "󰾹 "
                                                 :Class " "
                                                 :Color " "
                                                 :Constant " "
                                                 :Constructor "󰫣 "
                                                 :Enum " "
                                                 :EnumMember " "
                                                 :Event ""
                                                 :Field " "
                                                 :File " "
                                                 :Folder " "
                                                 :Function "󰊕"
                                                 :Interface " "
                                                 :Keyword " "
                                                 :Method " "
                                                 :Module "󱒌 "
                                                 :Number " "
                                                 :Operator " "
                                                 :Parameter " "
                                                 :Property " "
                                                 :Reference " "
                                                 :Snippet " "
                                                 :String " "
                                                 :Struct " "
                                                 :Text "󰬴 "
                                                 :TypeParameter " "
                                                 :Unit " "
                                                 :Value "󰞾 "
                                                 :Variable " "}
                                      :mode :short}}
                    :keymap {:recommended false
                             :manual_complete :<c-space>
                             :jump_to_mark :<c-j>}
                    :xdg true})
  (g :copilot_filetypes {:norg false})
  (g :diagnostic_auto_popup_while_jump 1)
  (g :diagnostic_enable_virtual_text 1)
  (g :diagnostic_insert_delay 1)
  (g :pandoc_preview_pdf_cmd :zathura)
  (g :space_before_virtual_text 2)
  (g :tex_conceal "")
  ;; neovim options
  (o :autoread true)
  (o :autowriteall true)
  (o :background :dark)
  (o :backup false)
  (o :breakindent true) ; Indents word-wrapped lines as much as the line above
  (o :clipboard :unnamedplus)
  (o :cmdheight 2)
  (o :complete ".,w,b,u,t,kspell") ; spell check
  (o :completeopt "menuone,noselect")
  (o :conceallevel 1)
  (o :cursorline true)
  (o :diffopt "hiddenoff,closeoff,internal,filler,indent-heuristic")
  (o :errorbells false)
  (o :equalalways true)
  (o :expandtab true)
  (o :fillchars "vert:│,fold:~,stl: ,stlnc: ")
  (o :foldexpr "nvim_treesitter#foldexpr()")
  (o :foldlevelstart 5)
  (o :foldmethod :expr)
  (o :formatoptions :lt) ; ensures word-wrap does not split words
  (o :hidden true)
  (o :ignorecase true)
  (o :showmode false)
  (o :lazyredraw true)
  (o :linebreak true)
  (o :list true)
  (o :listchars "tab:> ,trail:·")
  (o :mouse :a)
  (o :pumheight 20)
  (o :pumwidth 80)
  (o :scrolloff 5)
  (o :shiftwidth 4)
  (o :shortmess :caFTW)
  (o :showmode false)
  (o :smartindent true)
  (o :smartcase true)
  (o :softtabstop 4)
  (o :splitbelow true)
  (o :splitright true)
  (o :tabstop 4)
  (o :tags "./tags;")
  (o :termguicolors true)
  (o :textwidth 80)
  (o :timeoutlen 2000)
  (o :title false)
  (o :updatetime 300)
  (o :visualbell false)
  (o :writebackup false)
  (o :whichwrap "<,>,h,l")
  (o :wildignore
     "*/node_modules,*/node_modules/*,.git,.git/*,tags,*/dist,*/dist/*")
  (o :wrap true)
  (o :writebackup false)
  (o :swapfile false)
  (o :undofile false)
  (o :undolevels 100)
  (o :undoreload 1000)
  (o :updatetime 300)
  (wo :number true)
  (wo :relativenumber true)
  (wo :signcolumn "yes:1"))
