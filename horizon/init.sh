#!/bin/bash

IP_HOST="${IP_ADDRESS:-192.168.1.3}"
echo "hihi"
echo $IP_HOST

#Configure 
echo "sed -i 's/IP_ADDRESS/$IP_HOST/g' /etc/openstack-dashboard/local_settings.py" &&
sed 's+IP_ADDRESS+'"$IP_HOST+" /etc/openstack-dashboard/local_settings.py.example > /etc/openstack-dashboard/local_settings.py &&

echo "Starting apachectl"
/usr/sbin/apachectl -DFOREGROUND