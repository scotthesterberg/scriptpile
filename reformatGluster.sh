#!/usr/bin/env bash

for i in $(gluster volume list)
do
	gluster volume stop ${i}
	gluster volume delete ${i}
done

umount /gluster/brick*
mkfs.xfs -f -i size=512 -n size=8192 /dev/mapper/vg_brick1-lv_brick1 
mkfs.xfs -f -i size=512 -n size=8192 /dev/mapper/vg_brick2-lv_brick2 
mount -a

