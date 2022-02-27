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

# Unload all AMD drivers or exit
modprobe -r amdgpu || exit 1

# Detach GPU devices from host
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Load VFIO kernel module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
