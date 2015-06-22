#!/usr/bin/env bash

## Check for getopts vals
if [ $# -ne 2 ]; then
  echo "*******************************************"
  echo " Sorry, but I need two arguments to run."
  echo ""
  echo " Usage:"
  echo ""
  echo " $0 <volumename> <GlusterFS Peer IP>"
  echo ""
  echo "*******************************************"
  exit 1
fi

volName=$1
host1=10.10.0.3
host2=10.10.0.4

service glusterd restart; chkconfig glusterd on
ssh root@c2 "rm -rf /gluster/brick{1,2}/${volName}/;mkdir -p /gluster/brick{1,2}/${volName}/;service glusterd restart;chkconfig glusterd on"
gluster peer probe ${host2}
rm -rf /gluster/brick{1,2}/${volName}/
mkdir -p /gluster/brick{1,2}/${volName}/

gluster volume create ${volName} stripe 4 transport tcp host1:/gluster/brick1/${volName}/ 10.10.0.4:/gluster/brick1/${volName}/ host1:/gluster/brick2/${volName}/ 10.10.0.4:/gluster/brick2/${volName}/

gluster volume start ${volName}
gluster volume reset all
gluster volume set ${volName} group virt
gluster volume set ${volName} storage.owner-uid 36  
gluster volume set ${volName} storage.owner-gid 36  
gluster volume set ${volName} nfs.disable off
gluster volume set ${volName} cluster.stripe-coalesce on
gluster volume set ${volName} cluster.server-quorum-type server
gluster volume set ${volName} quorum-type auto
gluster volume info
