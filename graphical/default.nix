{ config, deviceInfo, lib, pkgs, ... }:

let
  inherit (lib) mkIf optionals;

  fontText = "Inter 12";
in
{
  config = mkIf (deviceInfo.graphical) {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = config.gtk.theme.name;
        icon-theme = config.gtk.iconTheme.name;
        cursor-theme = config.xsession.pointerCursor.name;
        font-name = "Inter 12";
      };
      "org/gnome/desktop/sound" = {
        theme-name = "musicaflight";
        event-sounds = true;
        input-feedback-sounds = true;
      };
    };

    fonts.fontconfig.enable = true;

    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic";
      };
      font = config.muse.theme.sansFont;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };
  };
}
