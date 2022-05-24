{ config, deviceInfo, lib, pkgs, ... }:

let
  inherit (lib) mkIf optionals;

  fontText = "Inter 12";

  # bemenu
  black = "#${config.muse.theme.colors.swatch.background}e5";
  white = "#${config.muse.theme.colors.swatch.foreground}";
  accent = "#${config.muse.theme.colors.swatch.accent}e5";
  bemenuArgs = [ "-H" "32" "--fn" fontText "--tb" "'${black}'" "--tf" "'${accent}'" "--fb" "'${black}'" "--ff" "'${white}'" "--nb" "'${black}'" "--nf" "'${accent}'" "--hb" "'${accent}'" "--hf" "'${black}'" "--sb" "'${accent}'" "--sf" "'${white}'" "--scrollbar" "autohide" "-f" "-m" "all" ];
  lockCmd = "$HOME/.config/sway/scripts/lock.fish --bg-color ${config.muse.theme.colors.swatch.background} --fg-color ${config.muse.theme.colors.swatch.foreground} --primary-color ${config.muse.theme.colors.swatch.accent} --warning-color ${config.muse.theme.colors.swatch.warning} --error-color ${config.muse.theme.colors.swatch.alert}";
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

    home = {
      packages = with pkgs;
        # stuff for my personal devices only
        lib.optionals (deviceInfo.personal) [
          # desktop environment
          bemenu
          eww-wayland
          flashfocus
          glib # for gtk theming
          ksshaskpass
          polkit_gnome
        ];

      pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic";
        size = 24;

        gtk.enable = true;
        x11.enable = true;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    wayland.windowManager.sway = import ../sway/mod.nix {
      inherit config lib pkgs bemenuArgs lockCmd;
      colors = config.muse.theme.colors;
    };
  };
}
