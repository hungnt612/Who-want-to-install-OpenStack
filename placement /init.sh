#!/bin/bash
IP_HOST="${IP_ADDRESS:-localhost}"
echo "hihi"
echo $IP_HOST


# chmod 640 /etc/placement/placement.conf
# chgrp nova /etc/placement/placement.conf
echo "placement-manage db sync" &&
su -s /bin/sh -c "placement-manage db sync" placement &&
placement-api &&
placement-manage &&
placement-status

# service nova-api restart
# service nova-scheduler restart
# service nova-conductor restart
# service nova-novncproxy restart