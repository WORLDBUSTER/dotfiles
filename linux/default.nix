{ deviceInfo, ... }:

{
  imports = [
    ./services.nix
  ] ++ (lib.optional deviceInfo.graphical ./graphical);

  home = {
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
    sessionVariables = {
      # from fish
      ANDROID_EMULATOR_USE_SYSTEM_LIBS = 1;
      BAT_THEME = "base16";
      BEMENU_BACKEND = "wayland";
      BROWSER = "firefox";
      EDITOR = "nvim";
      GPG_TTY = "$(tty)";
      GTK_THEME = config.gtk.theme.name;
      LC_COLLATE = "C";
      LEDGER_FILE = "$HOME/notebook/ledger/main.sfox";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_DBUS_REMOTE = 1;
      SUDO_ASKPASS = "ksshaskpass";
      WINEPREFIX = "$HOME/.wine/";

      # so ardour can detect plugins
      DSSI_PATH = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
      LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
      LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
      LXVST_PATH = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
      VST_PATH = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
      VST3_PATH = "$HOME/.vst3:$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3";
    };

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "municorn";
    homeDirectory = "/home/municorn";
  };

  muse.theme = {
    colors = (import ../colors.nix).duskfox;

    enable = true;
    sansFont = {
      package = pkgs.inter;
      name = "Inter";
      size = 12;
    };

    wallpapers = {
      dir = ../wallpapers;
      useMatchpal = true;
    };
  };

  systemd = import ./systemd.nix { inherit config pkgs; };

  xdg = {
    enable = true;
    configFile = {
      "inkscape/palettes/solarized_dark.gpl" = {
        source = ./inkscape/solarized_dark.gpl;
      };
      "muse-status/daemon.yaml".text = let inherit (lib) optionalString; in
        ''
          ---
          daemon_addr: "localhost:2899"
          primary_order:
            - date
            - weather
            - mpris
          secondary_order:
            - brightness
            - volume
            - network
            - battery
          tertiary_order: []
          brightness_id: amdgpu_bl0
          network_interface_name: wlan0
          battery_config:
            battery_id: BAT0
            warning_level:
              minutes_left: 60
            alarm_level:
              minutes_left: 30
          weather_config:
            openweathermap_key: d179cc80ed41e8080f9e86356b604ee3
            ipstack_key: 9c237911bdacce2e8c9a021d9b4c1317
            weather_icons:
              04d: 󰖐
              09d: 󰖗
              01n: 󰖔
              10n: 󰖖
              02n: 󰼱
              03d: 󰖐
              11n: 󰖓
              13n: 󰖘
              50n: 󰖑
              03n: 󰖐
              01d: 󰖙
              04n: 󰖐
              02d: 󰖕
              09n: 󰖗
              50d: 󰖑
              10d: 󰖖
              11d: 󰖓
              13d: 󰖘
            default_icon: 󰖐
            update_interval_minutes: 20
            units: imperial
        '';
      "peaclock.conf".source = ./peaclock.conf;
      "ranger" = {
        recursive = true;
        executable = true;
        source = ./ranger;
      };
      "sway/scripts" = {
        recursive = true;
        source = ./sway/scripts;
      };
      "sway/scripts/start_wob.sh" = {
        executable = true;
        text = import ./sway/wob_script.nix {
          backgroundColor = config.muse.theme.colors.swatch.black;
          borderColor = config.muse.theme.colors.swatch.gray;
          barColor = config.muse.theme.colors.swatch.accent;
        };
      };
      "waybar" = {
        recursive = true;
        source = ./waybar;
      };
    };
  };
}
