{ config, pkgs, ... }:
{
  # Boot configuration
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "video=efifb:off" ];
  boot.kernelModules = [ "kvm-amd" "vfio-pci" ];

  # Enable libvirtd
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.enable = true;
      runAsRoot = true;
    };
    extraConfig = ''
      unix_sock_group="libvirtd"
      unix_sock_rw_perms="0770"
      log_filters="1:qemu"
      log_outputs="1:journald"
    '';
  };

  systemd.services.libvirtd = {
    # Add binaries to path so that hooks can use it
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            sd
          ];
        };
      in
      [ env ];
  };

  # Enable xrdp
  services.xrdp.enable = true; # use remote_logout and remote_unlock
  services.xrdp.defaultWindowManager = "i3";
  systemd.services.pcscd.enable = false;
  systemd.sockets.pcscd.enable = false;

  # VFIO Packages installed
  environment.systemPackages = with pkgs; [
    virt-manager
    dconf # needed for saving settings in virt-manager
    libguestfs # needed to virt-sparsify qcow2 files
  ];

   # Link hooks to the correct directory
   system.activationScripts.libvirt-hooks.text =
     "ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks";

  environment.etc = {
    "libvirt/hooks/qemu" = {
      source = ./libvirt_hooks/qemu;
      mode = "0755";
    };

    "libvirt/hooks/kvm.conf" = {
      source = ./libvirt_hooks/kvm.conf;
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/prepare/begin/start.sh" = {
      source = ./libvirt_hooks/qemu.d/win10/prepare/begin/start.sh;
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/release/end/stop.sh" = {
      source = ./libvirt_hooks/qemu.d/win10/release/end/stop.sh;
      mode = "0755";
    };
  };
}
