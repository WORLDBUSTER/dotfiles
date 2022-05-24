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
}
