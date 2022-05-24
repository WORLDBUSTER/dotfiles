{ config, deviceInfo, lib, pkgs, ... }:

let
  inherit (lib) mkIf optionals;

  fontText = "Inter 12";
in
{
  config = mkIf (deviceInfo.graphical) {
  };
}
