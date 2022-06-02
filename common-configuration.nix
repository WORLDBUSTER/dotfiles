# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./cachix.nix
  ];

  boot = {
    kernel.sysctl = { "fs.inotify.max_user_watches" = 524288; };
    extraModulePackages = builtins.attrValues {
      inherit (config.boot.kernelPackages) v4l2loopback;
    };
    kernelModules = [ "v4l2loopback" ];
    kernelParams = [ "quiet" "fbcon=nodefer" "nohibernate" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;

        devices = [ "nodev" ];
        efiSupport = true;
        splashMode = "normal";
        version = 2;
      };
    };
    plymouth = {
      # enable = true;
      theme = "musicaloft-rainbow";
      themePackages = [
        pkgs.plymouth-theme-musicaloft-rainbow
      ];
    };
  };

  environment = {
    defaultPackages = with pkgs; [
      cachix
      ungoogled-chromium
      firefox
      kodi
      konsole
      ksshaskpass
      libcanberra
      libcanberra-gtk3
      muse-sounds
      openrgb
      pinentry
      pinentry-curses
      pinentry-gtk2
      v4l-utils
      wayfire

      # needed for xdg-open and such
      xdg-utils

      # needed for sway
      qt5.qtwayland
    ];

    systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

      # for creating bootable usbs
      ntfs3g

      # misc
      clinfo
      psmisc
      polkit_gnome
      vulkan-tools
    ];
  };

  fonts = {
    fonts = with pkgs; [
      google-fonts
      libertine
      inter-ui
      material-design-icons
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      iosevka-muse.normal
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Iosevka Muse" "Iosevka Nerd Font" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  hardware = {
    # Enable brillo
    brillo.enable = true;

    # Bluetooth
    bluetooth = {
      enable = true;
    };

    # CPU microcode
    cpu.amd.updateMicrocode = true;

    # Ledger
    ledger.enable = true;

    # enable driSupport for sway
    opengl = {
      enable = true;
      driSupport = true;
    };

    xpadneo.enable = true;
  };

  location.provider = "geoclue2";

  musnix.enable = true;

  networking = {
    wireless = {
      iwd = {
        enable = true; # Enables wireless support via iwd.
        settings = {
          Blacklist = {
            InitialTimeout = 10;
            Multiplier = 2;
            MaximumTimeout = 1800;
          };
        };
      };
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
    };

    # Encrypts network traffic where possible (i think)
    tcpcrypt.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };

  nix = {
    # enables flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "municorn" ];
    };
  };

  nixpkgs.config = {
    # allow some unfree packages to be installed
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "slack"
      "spotify"
      "spotify-unwrapped"
      "steam"
      "steam-original"
      "steam-runtime"

      "linuxsampler"
      "mpv-youtube-quality"
    ];
  };

  programs = {
    adb.enable = true;
    fish.enable = true;
    git.enable = true;

    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };

    gphoto2.enable = true;

    ssh = {
      setXAuthLocation = true;
    };

    steam.enable = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        grim
        kitty
        slurp
        swaybg
        swayidle
        swaylock
        wf-recorder
        wl-clipboard
        wob
      ];
    };
  };

  security = {
    polkit.enable = true;

    # for pipewire. optional, but recommended
    rtkit.enable = true;

    # for secure boot (i hope)
    tpm2.enable = true;
  };

  services = {
    atd.enable = true;

    auto-cpufreq.enable = true;

    fwupd.enable = true;

    geoclue2 = {
      enable = true;
      appConfig = {
        localtimed = {
          isSystem = true;
          isAllowed = true;
        };
        gammastep = {
          isSystem = false;
          isAllowed = true;
        };
      };
    };

    localtime.enable = true;

    logind.extraConfig = ''
      RuntimeDirectorySize=2G
    '';

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    sshguard = {
      enable = true;
    };

    xserver = {
      # Enable the Plasma 5 Desktop Environment.
      desktopManager.plasma5.enable = true;

      # Configure keymap in X11
      layout = "us";

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # wacom tablet support
      wacom.enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      municorn = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "video" "camera" "docker" "kvm" "plugdev" "libvirtd" "nixos-config" "adbusers" ];
        home = "/home/municorn";
      };
      beans = {
        isNormalUser = true;
        extraGroups = [ "audio" "video" ];
        home = "/home/beans";
      };
      tcpcryptd.group = "tcpcryptd";
    };
    groups = {
      nixos-config = { };
      tcpcryptd = { };
    };
    defaultUserShell = pkgs.fish;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
      wlr.enable = true;
    };
    sounds.enable = true;
  };
}

