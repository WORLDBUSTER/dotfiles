{ bemenuArgs, colors, deviceInfo, lib, lockCmd, pkgs }:

{
  dunst = import ../dunst.nix { inherit lib pkgs bemenuArgs colors; };

  gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature.night = 1500;

    settings = {
      general = {
        adjustment-method = "wayland";
      };
    };
  };

  kdeconnect.enable = true;

  muse-status.enable = true;
}
