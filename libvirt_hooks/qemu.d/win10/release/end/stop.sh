#!/usr/bin/env bash

# print commands as they are run
set -x

# Load variables we defined
source "/etc/libvirt/hooks/kvm.conf"

# Unload VFIO-PCI Kernel Driver
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Attach GPU devices from host
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# Load AMD drivers
modprobe snd_hda_intel
modprobe amdgpu
#echo -n "pci_0000_28_00_1" > /sys/bus/pci/drivers/snd_hda_intel/bind
#echo -n "pci_0000_28_00_0" > /sys/bus/pci/drivers/amdgpu/bind

# Reload any graphical sessions
# *shrug*
