(let [alpha-nvim (require :alpha)
      dashboard (require :alpha.themes.dashboard)
      fortune-handle (io.popen "fortune -s")
      fortune (fortune-handle:read :*a)
      kitty ["     /| " " )  ( ')" "(  /  ) " " \\(__)| "]]
  (fortune-handle:close)
  (set dashboard.section.buttons.val
       [(dashboard.button :e "  New file" ":ene <bar> startinsert<cr>")
        (dashboard.button ", f d" "  Find file" ":Telescope find_files<cr>")
        (dashboard.button ", f o" "  Recent files" ":Telescope oldfiles<cr>")
        (dashboard.button ", g g" "龎 Find words" ":Telescope live_grep<cr>")
        (dashboard.button ", f g" "  Git status" ":Telescope git_status<cr>")
        (dashboard.button :q "  Quit" ":qa<cr>")])
  (alpha-nvim.setup dashboard.config))
