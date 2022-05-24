{ bemenuArgs, colors, deviceInfo, lib, lockCmd, pkgs }:

{
  gpg-agent = {
    enable = true;
    maxCacheTtl = 86400;
    defaultCacheTtl = 86400;
    extraConfig = "no-allow-external-cache";
  };

  spotifyd = import ./spotifyd/mod.nix { inherit deviceInfo pkgs; };

  syncthing.enable = true;
}
