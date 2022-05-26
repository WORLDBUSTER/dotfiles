# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "littlepony";
  };

  services = {
    openssh = {
      enable = true;
      forwardX11 = true;
    };
  };

  systemd = {
    services."systemd-backlight@backlight:acpi_video0".enable = false;
    targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
      suspend-then-hibernate.enable = false;
    };
  };

  # not in common-configuration
  virtualisation.docker.extraOptions = "--data-root /home/docker/";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  users.users.municorn.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKecJ3pKjKhMvGWKA2pFYc1++yOKXgIkUN8E/F7gseFH municorn@ponycastle"
  ];
}

