#!/bin/bash

KEYSTONE_HOST="${IP_ADDRESS:-localhost}"
echo "hihi"
echo $KEYSTONE_HOST

#Configure Keystone

# cat /etc/keystone/keystone.conf
# chown -R keystone:keystone /etc/keystone

# su -s /bin/bash keystone -c "keystone-manage db_sync"
# keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
# keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

#Configure Apache httpd


# Start Apache / Keystone Service
apachectl -D FOREGROUND &
keystone-manage bootstrap --bootstrap-password adminpassword \
--bootstrap-admin-url http://$KEYSTONE_HOST:5000/v3/ \
--bootstrap-internal-url http://$KEYSTONE_HOST:5000/v3/ \
--bootstrap-public-url http://$KEYSTONE_HOST:5000/v3/ \
--bootstrap-region-id RegionOne



tail -f /var/log/apache2/*