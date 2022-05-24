{ bemenuArgs, colors, deviceInfo, lib, lockCmd, pkgs }:

{
  dunst = import ../dunst.nix { inherit lib pkgs bemenuArgs colors; };
}
