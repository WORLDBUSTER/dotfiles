{ config, deviceInfo, lib, pkgs, colors, bemenuArgs }:

{
  browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };

  firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  kitty = import ../kitty.nix { inherit colors pkgs; };

  mpv = {
    enable = true;
    config = {
      osc = "no";
      hwdec = "auto";
      force-window = "yes";
    };
    scripts = builtins.attrValues {
      inherit (pkgs.mpvScripts)
        mpris
        thumbnail
        youtube-quality;
    };
  };
}
