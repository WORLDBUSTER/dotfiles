{
  programs.nixvim.globals = {
    mapleader = ",";
    # plugin configs
    diagnostic_auto_popup_while_jump = 1;
    diagnostic_enable_virtual_text = 1;
    diagnostic_insert_delay = 1;
    pandoc_preview_pdf_cmd = "zathura";
    space_before_virtual_text = 2;
    tex_conceal = "";
  };
}
