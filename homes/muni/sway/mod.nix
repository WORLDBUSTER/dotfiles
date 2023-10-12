{ config, lib, pkgs, colors, bemenuArgs, ... }:

let
  sup = "Mod4";
  alt = "Mod1";

  font = {
    names = [ "Inter" ];
    style = "Regular";
    size = 12.0;
  };

  # bemenuArgs as a string
  bemenuArgsJoined = lib.strings.concatStringsSep " " bemenuArgs;

  # background colors
  black = "#${colors.swatch.background}e5";
  gray = "#${colors.swatch.gray}e5";

  # foreground colors
  white = "#${colors.swatch.foreground}";
  silver = "#${colors.swatch.silver}";

  # other colors
  accent = "#${colors.swatch.accent}e5";
  warning = "#${colors.swatch.warning}e5";

  lockCmd = "$HOME/.config/sway/scripts/lock.fish --bg-color ${colors.swatch.background} --fg-color ${colors.swatch.foreground} --primary-color ${colors.swatch.accent} --warning-color ${colors.swatch.warning} --error-color ${colors.swatch.alert}";

  dpmsOff = "swaymsg 'output * dpms off'";
  dpmsOn = "swaymsg 'output * dpms on'";

  scriptsDir = builtins.path { name = "sway-scripts"; path = ./scripts; };

  # define names for default workspaces for which we configure key bindings later
  # on. we use variables to avoid repeating the names in multiple places.
  workspaceNames = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "X" ];
  workspace = builtins.elemAt workspaceNames;
in
{
  enable = true;
  config = {
    bars = [{
      fonts = font;
      position = "top";
      extraConfig = ''
        separator_symbol "    "
        status_edge_padding 16
        height 32
        modifier "${sup}"
      '';
      statusCommand = "${pkgs.muse-status}/bin/muse-status sub a -m i3 -p ${colors.swatch.white} -s ${colors.swatch.accent}";
      trayOutput = "none";
      workspaceButtons = true;
      colors = {
        activeWorkspace = { background = black; border = black; text = silver; };
        background = black;
        bindingMode = { background = black; border = black; text = warning; };
        focusedWorkspace = { background = black; border = black; text = white; };
        statusline = white;
        inactiveWorkspace = { background = black; border = black; text = accent; };
        separator = accent;
        urgentWorkspace = { background = warning; border = warning; text = black; };
      };
    }];

    colors = {
      background = black;
      focused = { border = gray; background = gray; text = white; indicator = accent; childBorder = gray; };
      focusedInactive = { border = black; background = black; text = silver; indicator = black; childBorder = black; };
      unfocused = { border = black; background = black; text = accent; indicator = black; childBorder = black; };
      urgent = { border = warning; background = warning; text = black; indicator = accent; childBorder = warning; };
    };

    defaultWorkspace = "workspace ${workspace 0}";

    floating = {
      border = 6;
      modifier = sup;
      titlebar = true;

      criteria = [
        { title = "Lutris"; }
        { title = "OpenRGB"; }
        { title = "Extension:.*Firefox"; }
      ];
    };

    focus = {
      followMouse = "always";
      newWindow = "smart";
    };

    fonts = font;

    gaps = {
      inner = 16;
      smartBorders = "on";
      smartGaps = true;
    };

    input = {
      "2:7:SynPS/2_Synaptics_TouchPad" = {
        tap = "enabled";
        natural_scroll = "enabled";
      };

      "1267:9527:ELAN0732:00_04F3:2537" = {
        map_to_output = "eDP-1";
      };

      "*" = {
        xkb_layout = "us";
      };
    };

    keybindings = import ./keys.nix { inherit config lib pkgs sup alt bemenuArgsJoined lockCmd workspace scriptsDir; };

    menu = "bemenu-run -p 'Run what?' ${bemenuArgsJoined}";

    # no modes
    modes = { };

    modifier = "${sup}";

    output = {
      # for laptop
      "eDP-1" = {
        pos = "0 0";
      };

      # for ponytower
      "Acer Technologies SB220Q 0x00007C0D" = {
        pos = "0 0";
      };
      "Acer Technologies SB220Q 0x000035FB" = {
        pos = "1920 0";
      };

      # for all
      "*" = {
        background = ''"$HOME/Pictures/Wallpapers/Photos/solarized/Corn.jpg" fill'';
      };
    };

    # startup apps
    startup =
      let
        lockWarningCmd = "notify-send -u low -t 29500 -- 'Are you still there?' 'Your system will lock itself soon.'";
      in
      [
        # startup other things
        { command = ''brillo -I''; }
        { command = ''swayidle -w timeout 570 "${lockWarningCmd}" timeout 600 "${lockCmd}" timeout 630 "${dpmsOff}" resume "${dpmsOn}" before-sleep "${lockCmd}"''; }
        { command = ''xhost si:localuser:root''; }
        { command = ''xrdb -load ~/.Xresources''; }

        # wob
        { command = "$HOME/.config/sway/scripts/start_wob.sh"; }

        # play startup sound
        { command = ''canberra-gtk-play --id=desktop-login''; }
      ];

    terminal = "kitty";

    window = {
      border = 6;
      hideEdgeBorders = "smart";
      titlebar = true;

      commands = [
        { command = "floating enable, resize set 600 px 400 px"; criteria = { title = "Page Unresponsive"; }; }
        { command = "floating enable, resize set 64 px 32 px, move position 256 px -70 px, border csd"; criteria = { title = "Firefox — Sharing Indicator"; }; }
        { command = "floating enable, sticky enable, resize set 30 ppt 60 ppt"; criteria = { app_id = "^launcher$"; }; }
        { command = "inhibit_idle fullscreen"; criteria = { class = ".*"; }; }
      ];
    };

    workspaceAutoBackAndForth = true;
  };

  extraConfig = builtins.readFile ./config;

  extraSessionCommands = ''
    export CLUTTER_BACKEND=wayland
    export ECORE_EVAS_ENGINE=wayland-egl
    export ELM_ENGINE=wayland_egl
    export MOZ_ENABLE_WAYLAND=1
    export NO_AT_BRIDGE=1
    export QT_QPA_PLATFORM=wayland-egl
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland
  '';

  systemdIntegration = true;

  wrapperFeatures = {
    base = true;
    gtk = true;
  };

  xwayland = true;
}
