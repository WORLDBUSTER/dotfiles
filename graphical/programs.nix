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
}
