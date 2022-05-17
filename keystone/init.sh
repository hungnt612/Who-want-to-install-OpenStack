#!/bin/bash

IP_HOST="${IP_ADDRESS:-192.168.1.3}"
echo "hihi"
echo $IP_HOST

#Configure Keystone

# cat > ~/keystonerc <<EOF
# export OS_PROJECT_DOMAIN_NAME=default
# export OS_USER_DOMAIN_NAME=default
# export OS_PROJECT_NAME=admin
# export OS_USERNAME=admin
# export OS_PASSWORD=adminpassword
# export OS_AUTH_URL=http://192.168.1.3/v3
# export OS_IDENTITY_API_VERSION=3
# export OS_IMAGE_API_VERSION=2
# export PS1='\u@\h \W(keystone)\$ '
# EOF
chown -R keystone:keystone /etc/keystone
su -s /bin/bash keystone -c "keystone-manage db_sync"
touch ~/keystonerc  
echo "export OS_PROJECT_DOMAIN_NAME=default" >> ~/keystonerc
echo "export OS_USER_DOMAIN_NAME=default" >> ~/keystonerc
echo "export OS_PROJECT_NAME=admin" >> ~/keystonerc
echo "export OS_USERNAME=admin" >> ~/keystonerc
echo "export OS_PASSWORD=adminpassword" >> ~/keystonerc
echo "export OS_AUTH_URL=http://192.168.1.3/v3" >> ~/keystonerc
echo "export OS_IDENTITY_API_VERSION=3" >> ~/keystonerc
echo "export OS_IMAGE_API_VERSION=2" >> ~/keystonerc
echo "export PS1='\u@\h \W(keystone)\$ ' " >> ~/keystonerc

# cat /etc/keystone/keystone.conf

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone &&
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone &&
keystone-manage bootstrap --bootstrap-password adminpassword --bootstrap-admin-url http://192.168.1.3:5000/v3/ --bootstrap-internal-url http://192.168.1.3:5000/v3/ --bootstrap-public-url http://192.168.1.3:5000/v3/ --bootstrap-region-id RegionOne &&
chmod 600 ~/keystonerc &&
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then     touch $CONTAINER_ALREADY_STARTED;     echo "-- First container startup --";     source ~/keystonerc && openstack project create --domain default --description "Service Project" service && openstack project list;     wait; else     echo "-- Not first container startup --"; fi &&
tail -f /var/log/keystone/*