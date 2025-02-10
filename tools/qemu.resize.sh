#!/bin/bash

# qemu-img resize ......qcow2 50G

# zB qemu-img resize /var/lib/libvirt/images/xyz.qcow2 30G
also die zahl gibt an was danach total verwendet werden soll, also das ist nicht 30GB mehr sondern > total 30GB <

#
# in der VM: growpart /dev/vda 1
#
# in der VM: resize2fs /dev/vda1
