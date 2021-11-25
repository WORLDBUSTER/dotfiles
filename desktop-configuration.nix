# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include shared configuration between systems and hardware configuration
      ./common-configuration.nix
      ./desktop-hardware.nix
      ./vfio.nix
    ];

  networking = {
    hostName = "ponytower";
  };

  # allow steam to be installed (it's unfree)
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  programs.steam.enable = true;

  systemd.services.openrgb = {
    enable = true;

    description = "OpenRGB server";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openrgb}/bin/openrgb --server";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

