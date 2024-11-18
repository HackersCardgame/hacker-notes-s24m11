#!/bin/bash

# qemu-img resize ......qcow2 50G
# zB qemu-img resize /var/lib/libvirt/images/xyz.qcow2 30G

#
# in der VM: growpart /dev/vda 1
#
# in der VM: resize2fs /dev/vda1
