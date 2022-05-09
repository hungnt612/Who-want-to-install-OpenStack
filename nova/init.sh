#!/bin/bash

# KEYSTONE_HOST="${IP_ADDRESS:-localhost}"
# echo "hihi"
# echo $KEYSTONE_HOST

# chmod 640 /etc/nova/nova.conf
# chgrp nova /etc/nova/nova.conf

# chmod 640 /etc/placement/placement.conf
# chgrp nova /etc/placement/placement.conf



/usr/bin/nova-api  &&
/usr/bin/nova-scheduler &
/usr/bin/nova-conductor &
/usr/bin/nova-novncproxy &
/usr/bin/nova-api &
/usr/bin/nova-cert &
/usr/bin/nova-compute &
/usr/bin/nova-consoleauth &
/usr/bin/nova-network &
/usr/bin/nova-manage


tail -f /var/log/nova/*

# service nova-api restart
# service nova-scheduler restart
# service nova-conductor restart
# service nova-novncproxy restart