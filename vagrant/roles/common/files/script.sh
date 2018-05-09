#!/bin/bash

ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
sed -i "s/peeraddress.*/peeraddress = $ip4:24007/g" /etc/glusterd2/glusterd2.toml
sed -i "s/clientaddress.*/clientaddress = $ip4:24007/g" /etc/glusterd2/glusterd2.toml