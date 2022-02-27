#!/usr/bin/env bash

# print commands as they are run
set -x

# Load variables we defined
source "/etc/libvirt/hooks/kvm.conf"

# Stop graphical sessions
# *shrug*

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Avoid a race condition
sleep 5

# Unload all AMD drivers
echo -n 0000:28:00.1 > /sys/bus/pci/drivers/snd_hda_intel/unbind
echo -n 0000:28:00.0 > /sys/bus/pci/drivers/amdgpu/unbind
modprobe -r amdgpu
modprobe -r snd_hda_intel

# Detach GPU devices from host
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Load VFIO kernel module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
