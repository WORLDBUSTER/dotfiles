{ pkgs, bemenuOpts, colors, ... }:

{
  dunst = import ./dunst.nix { inherit pkgs bemenuOpts colors; };

  gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      night = 1500;
    };
    settings = {
      general = {
        adjustment-method = "wayland";
      };
    };
  };

  keybase.enable = true;

  kbfs = {
    enable = true;
  };

  spotifyd = import ./spotifyd/mod.nix { inherit pkgs; };

  syncthing.enable = true;

  udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };
}
