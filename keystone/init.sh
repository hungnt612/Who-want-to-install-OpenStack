#!/bin/bash

IP_HOST="${IP_ADDRESS:-192.168.1.3}"
echo "hihi"
echo $IP_HOST

#Configure Keystone
chown -R keystone:keystone /etc/keystone &&
echo "test 1" &&
su -s /bin/bash keystone -c "keystone-manage db_sync" && 
echo "test 2" &&
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone &&
echo "test 3" &&
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone &&
echo "test 4" &&
keystone-manage bootstrap --bootstrap-password adminpassword \
--bootstrap-admin-url http://$IP_HOST:5000/v3/ \
--bootstrap-internal-url http://$IP_HOST:5000/v3/ \
--bootstrap-public-url http://$IP_HOST:5000/v3/ \
--bootstrap-region-id RegionOne

echo "Starting apachectl"
/usr/sbin/apachectl -DFOREGROUND