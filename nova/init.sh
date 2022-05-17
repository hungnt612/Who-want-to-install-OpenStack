#!/bin/bash
IP_HOST="${IP_ADDRESS:-localhost}"
echo "hihi"
echo $IP_HOST
# KEYSTONE_HOST="${IP_ADDRESS:-localhost}"
# echo "hihi"
# echo $KEYSTONE_HOST

# chmod 640 /etc/nova/nova.conf
# chgrp nova /etc/nova/nova.conf

# chmod 640 /etc/placement/placement.conf
# chgrp nova /etc/placement/placement.conf
echo "sed -i 's/IP_ADDRESS/$IP_HOST/g' /etc/nova/nova.conf" &&
sed 's+IP_ADDRESS+'"$IP_HOST+" /etc/nova/nova.conf &&
echo "placement-manage db sync" &&
su -s /bin/bash placement -c "placement-manage db sync" &&
echo "nova-manage api_db sync" &&
su -s /bin/bash nova -c "nova-manage api_db sync" &&
echo "nova-manage cell_v2 map_cell0" &&
su -s /bin/bash nova -c "nova-manage cell_v2 map_cell0" &&
echo "nova-manage db sync" &&
su -s /bin/bash nova -c "nova-manage db sync" &&
echo "nova-manage cell_v2 create_cell --name cell1" &&
su -s /bin/bash nova -c "nova-manage cell_v2 create_cell --name cell1"
echo "nova-manage cell_v2 discover_hosts" &&
su -s /bin/bash nova -c "nova-manage cell_v2 discover_hosts" &&
# /usr/bin/nova-api &&
# /usr/bin/nova-scheduler &
# /usr/bin/nova-conductor &
# /usr/bin/nova-novncproxy &
# /usr/bin/nova-api &
# /usr/bin/nova-cert &
# /usr/bin/nova-compute &
# /usr/bin/nova-consoleauth &
# /usr/bin/nova-network &
# /usr/bin/nova-manage

#start nova service
nova-api &
nova-cert &
nova-consoleauth &
nova-scheduler &
nova-conductor &
nova-novncproxy &
tail -f /var/log/nova/*

# service nova-api restart
# service nova-scheduler restart
# service nova-conductor restart
# service nova-novncproxy restart