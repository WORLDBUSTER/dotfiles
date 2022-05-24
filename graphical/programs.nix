{ config, deviceInfo, lib, pkgs, colors, bemenuArgs }:

{
  browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };
}
