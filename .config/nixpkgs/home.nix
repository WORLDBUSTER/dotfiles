{ config, lib, pkgs, ... }:

let
  colors = (import ./colors.nix).eevee;

  fontText = "Inter 12";

  # bemenu
  black = "#${colors.palette.background}e5";
  white = "#${colors.palette.foreground}";
  primary = "#${colors.palette.primary}e5";
  bemenuOpts = ''-H 32 --fn ${fontText} --tb '${black}' --tf '${primary}' --fb '${black}' --ff '${white}' --nb '${black}' --nf '${primary}' --hb '${primary}' --hf '${black}' --sb '${primary}' --sf '${white}' --scrollbar autohide -f -m all'';
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  accounts.email = import ./email/mod.nix { inherit config; };

  home = {
    packages = with pkgs; [
      # desktop environment
      bemenu
      bibata-cursors
      grim
      ksshaskpass
      polkit_gnome
      slurp
      swaybg
      swayidle
      swaylock
      wl-clipboard
      wob
      wpgtk
      xdg-desktop-portal-wlr

      # terminal stuff
      fd
      fish
      gnupg
      neovim-remote
      notify-desktop
      pinentry
      pinentry-curses
      playerctl
      ranger
      ripgrep
      sd
      spotify-tui
      zip

      # fish plugins
      fishPlugins.done
      fishPlugins.foreign-env

      # programming
      docker-compose
      gcc
      nodejs
      nodePackages.npm
      python3
      rustup
      tree-sitter

      # sound
      pamixer

      # video
      blender

      # email
      hydroxide

      # other apps
      android-file-transfer
      awf
      element-desktop
      gimp
      inkscape
      imv
      keepassxc
      kodi
      ledger-live-desktop
      mpv-with-scripts
      pavucontrol
      signal-desktop
      slack
      spotify

      # other things
      xorg.xcursorgen
    ];

    extraOutputsToInstall = [ "doc" "info" "devdoc" ];
    sessionPath = [
      "$HOME/.npm-global/bin"
      "$HOME/.npm-packages/bin"
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
      EIX_LIMIT = 0;
      FZF_DEFAULT_COMMAND = ''ag --hidden --ignore .git --ignore node_modules -g ""'';
      GPG_TTY = "$(tty)";
      GTK_THEME = "Arc-Dark";
      LEDGER_FILE = "$HOME/Notebook/ledger/main.sfox";
      MOZ_ENABLE_WAYLAND = 1;
      SUDO_ASKPASS = "ksshaskpass";
      WINEPREFIX = "$HOME/.wine/";
      XBPS_DISTDIR = "$HOME/code/void/packages";
      XDG_CURRENT_DESKTOP = "sway";
    };

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "municorn";
    homeDirectory = "/home/municorn";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Arc-Dark";
      icon-theme = "Arc";
      cursor-theme = "Bibata_Classic";
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
    font = {
      package = pkgs.inter-ui;
      name = "Inter";
      size = 12;
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name="Bibata_Classic"
      gtk-cursor-theme-size=24
    '';
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Bibata_Classic";
      gtk-cursor-theme-size = 24;
    };
  };

  manual.html.enable = true;

  programs = import ./programs.nix { inherit pkgs colors; };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  services = import ./services.nix { inherit pkgs bemenuOpts colors; };

  systemd = import ./systemd.nix { inherit config pkgs; };

  wayland.windowManager.sway = import ./sway/mod.nix { inherit config lib colors bemenuOpts; };

  xdg = {
    enable = true;
    configFile = {
      "nvim/lua" = {
        recursive = true;
        source = ./nvim/files/lua;
      };
      "nvim/pandoc-preview.sh" = {
        source = ./nvim/files/pandoc-preview.sh;
        executable = true;
      };
    };
  };

  xsession = {
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata_Classic";
      size = 24;
    };
  };
}

# vim: ts=2 sw=2 expandtab
