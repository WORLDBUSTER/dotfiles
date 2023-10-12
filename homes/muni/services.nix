{
  bemenuArgs,
  colors,
  config,
  deviceInfo,
  lib,
  pkgs,
}: {
  dunst = import ./dunst.nix {inherit config lib pkgs bemenuArgs colors;};

  gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 7500;
      night = 1500;
    };

    settings = {
      general = {
        adjustment-method = "wayland";
      };
    };
  };

  gnome-keyring.enable = true;

  gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;

    enableSshSupport = true;
    defaultCacheTtlSsh = 86400;
    maxCacheTtlSsh = 86400;
    sshKeys = ["23BF04AE05B5DAC1267FE74CD9F1DB7D2367AAE8"];

    extraConfig = "no-allow-external-cache";
  };

  kdeconnect.enable = true;

  muse-status.enable = true;

  spotifyd = import ./spotifyd.nix {inherit config deviceInfo pkgs;};

  swayidle = {
    enable = true;

    events = [
      {
        event = "before-sleep";
        command = "${lockCmd}";
      }
    ];
    timeouts = let
      lockWarningCmd = "${pkgs.libnotify}/bin/notify-send -u low -t 29500 'Are you still there?' 'Your system will lock itself soon.'";
      powerOff = "${pkgs.sway}/bin/swaymsg 'output * power off'";
      powerOn = "${pkgs.sway}/bin/swaymsg 'output * power on'";
    in [
      {
        timeout = 570;
        command = lockWarningCmd;
      }
      {
        timeout = 600;
        command = "${lockCmd}";
      }
      {
        timeout = 610;
        command = powerOff;
        resumeCommand = powerOn;
      }
    ];
  };

  syncthing.enable = true;
}
