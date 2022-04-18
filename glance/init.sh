#!/bin/bash

KEYSTONE_HOST="${IP_ADDRESS:-localhost}"
echo "hihi"
echo $KEYSTONE_HOST

#Install missing module


chmod 640 /etc/glance/glance-api.conf
chown root:glance /etc/glance/glance-api.conf


# start glance service
/usr/bin/glance-glare --config-file=/etc/glance/glance-glare.conf &&
/usr/bin/glance-registry --config-file=/etc/glance/glance-registry.conf &
/usr/bin/glance-api --config-file=/etc/glance/glance-api.conf