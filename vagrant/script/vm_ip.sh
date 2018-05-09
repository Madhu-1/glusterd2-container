#!/bin/bash
for vm in glusterd20 glusterd21 glusterd22
do
newip=$(vagrant ssh $vm  -c "/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1" |tail -2|awk '{print $4}')
echo '--------------------------------------------'
echo "VM Name   " $vm "IP   " $newip
echo '--------------------------------------------'
echo ""
done 
exit 0