#!/bin/bash

IP_HOST="${IP_ADDRESS:-localhost}"
echo "hihi"
echo $IP_HOST
echo "chmod 640 /etc/glance/glance-api.conf" &&
chmod 640 /etc/glance/glance-api.conf && 
echo "chown root:glance /etc/glance/glance-api.conf " &&
chown root:glance /etc/glance/glance-api.conf
echo "su -s /bin/bash glance -c 'glance-manage db_sync'" &&
su -s /bin/bash glance -c "glance-manage db_sync" &&
echo  "/usr/bin/glance-glare --config-file=/etc/glance/glance-glare.conf" &&
# start glance service
# /usr/bin/glance-glare --config-file=/etc/glance/glance-glare.conf &&
# echo  "/usr/bin/glance-registry --config-file=/etc/glance/glance-registry.conf" &&
# /usr/bin/glance-registry --config-file=/etc/glance/glance-registry.conf &&
echo  "/usr/bin/glance-api --config-file=/etc/glance/glance-api.conf" &&
/usr/bin/glance-api --config-file=/etc/glance/glance-api.conf