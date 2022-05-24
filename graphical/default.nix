{ config, deviceInfo, lib, pkgs, ... }:

let
  inherit (lib) mkIf optionals;
in
{
  config = mkIf (deviceInfo.graphical) {
  };
}
