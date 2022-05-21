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
sed 's+IP_ADDRESS+'"$IP_HOST+" /etc/nova/nova.conf.example > /etc/nova/nova.conf &&
chmod 777 /etc/nova/nova.conf  &&
chgrp nova /etc/nova/nova.conf  &&
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
echo "nova-manage db sync" &&
su -s /bin/bash nova -c "nova-manage db sync" &&
echo "nova-manage cell_v2 list_cells" &&
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova  &&
service nova-api restart &&
service nova-scheduler restart &&
service nova-conductor restart &&
service nova-novncproxy restart &&
tail -f /var/log/nova/*

# service nova-api restart
# service nova-scheduler restart
# service nova-conductor restart
# service nova-novncproxy restart