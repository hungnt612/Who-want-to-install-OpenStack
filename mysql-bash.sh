mysql -uroot
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'jitsinnovationlabs-mysqldb' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb' WITH GRANT OPTION ;FLUSH PRIVILEGES;
DROP USER 'root'@'::1';

exit
jitsinnovationlabs-mysqldb
jitsinnovationlabs-rabbitmq
jitsinnovationlabs-openstack



sed -i '/ETCD_LISTEN_PEER_URLS=/cETCD_LISTEN_PEER_URLS="http://192.168.1.150:2380"' /etc/etcd/etcd.conf

sed -i '/ETCD_LISTEN_CLIENT_URLS=/cETCD_LISTEN_CLIENT_URLS="http://192.168.1.150:2379"' /etc/etcd/etcd.conf

sed -i '/ETCD_NAME=/cETCD_NAME="controller"' /etc/etcd/etcd.conf

sed -i '/ETCD_INITIAL_ADVERTISE_PEER_URLS=/cETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.1.150:2380"' /etc/etcd/etcd.conf

sed -i '/ETCD_ADVERTISE_CLIENT_URLS=/cETCD_ADVERTISE_CLIENT_URLS="http://192.168.1.150:2379"' /etc/etcd/etcd.conf

sed -i '/ETCD_INITIAL_CLUSTER=/cETCD_INITIAL_CLUSTER="controller=http://192.168.1.150:2380"' /etc/etcd/etcd.conf

sed -i '/ETCD_INITIAL_CLUSTER_TOKEN=/cETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"' /etc/etcd/etcd.conf

sed -i '/ETCD_INITIAL_CLUSTER_STATE=/cETCD_INITIAL_CLUSTER_STATE="new"' /etc/etcd/etcd.conf


GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
FLUSH PRIVILEGES;"

crudini --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:jitsinnovationlabs-mysqldb@192.168.1.150/keystone

crudini --set /etc/keystone/keystone.conf token provider fernet

keystone-manage bootstrap --bootstrap-password jitsinnovationlabs-openstack \
--bootstrap-admin-url http://192.168.1.150:5000/v3/ \
--bootstrap-internal-url http://192.168.1.150:5000/v3/ \
--bootstrap-public-url http://192.168.1.150:5000/v3/ \
--bootstrap-region-id RegionOne

sed -i 's/#ServerName www.example.com:80/ServerName controller/g' /etc/httpd/conf/httpd.conf


cat << EOF > /root/admin-openrc
export OS_USERNAME=admin
export OS_PASSWORD=jitsinnovationlabs-openstack
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://192.168.1.150:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export OS_VOLUME_API_VERSION=3
EOF


mysql -uroot -pjitsinnovationlabs-mysqldb -e "CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
FLUSH PRIVILEGES;"


openstack user create  glance --domain default --password jitsinnovationlabs-openstack

openstack role add --project service --user glance admin

openstack service create --name glance --description "OpenStack Image" image

openstack endpoint create --region RegionOne image public http://192.168.1.150:9292

openstack endpoint create --region RegionOne image internal http://192.168.1.150:9292

openstack endpoint create --region RegionOne image admin http://192.168.1.150:9292



crudini --set /etc/glance/glance-api.conf database connection  mysql+pymysql://glance:jitsinnovationlabs-mysqldb@192.168.1.150/glance

crudini --set /etc/glance/glance-api.conf keystone_authtoken www_authenticate_uri http://192.168.1.150:5000
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://192.168.1.150:5000
crudini --set /etc/glance/glance-api.conf keystone_authtoken memcached_servers 192.168.1.150:11211
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_type password 
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_domain_name Default
crudini --set /etc/glance/glance-api.conf keystone_authtoken user_domain_name Default
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_name service
crudini --set /etc/glance/glance-api.conf keystone_authtoken username glance
crudini --set /etc/glance/glance-api.conf keystone_authtoken password jitsinnovationlabs-openstack

crudini --set /etc/glance/glance-api.conf paste_deploy flavor keystone

crudini --set /etc/glance/glance-api.conf glance_store stores file,http
crudini --set /etc/glance/glance-api.conf glance_store default_store file
crudini --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir /var/lib/glance/images/


mysql -uroot -pjitsinnovationlabs-mysqldb -e "CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
FLUSH PRIVILEGES;"

openstack user create  placement --domain default --password jitsinnovationlabs-openstack

openstack role add --project service --user placement admin

openstack service create --name placement --description "Placement API" placement

openstack endpoint create --region RegionOne placement public http://192.168.1.150:8778

openstack endpoint create --region RegionOne placement internal http://192.168.1.150:8778

openstack endpoint create --region RegionOne placement admin http://192.168.1.150:8778


crudini --set  /etc/placement/placement.conf placement_database connection mysql+pymysql://placement:jitsinnovationlabs-mysqldb@192.168.1.150/placement
crudini --set  /etc/placement/placement.conf api auth_strategy keystone
crudini --set  /etc/placement/placement.conf keystone_authtoken auth_url  http://192.168.1.150:5000/v3
crudini --set  /etc/placement/placement.conf keystone_authtoken memcached_servers 192.168.1.150:11211
crudini --set  /etc/placement/placement.conf keystone_authtoken auth_type password
crudini --set  /etc/placement/placement.conf keystone_authtoken project_domain_name Default
crudini --set  /etc/placement/placement.conf keystone_authtoken user_domain_name Default
crudini --set  /etc/placement/placement.conf keystone_authtoken project_name service
crudini --set  /etc/placement/placement.conf keystone_authtoken username placement
crudini --set  /etc/placement/placement.conf keystone_authtoken password jitsinnovationlabs-openstack


mysql -uroot -pjitsinnovationlabs-mysqldb -e "CREATE DATABASE nova_api;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';

CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';

CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
FLUSH PRIVILEGES;"


openstack user create nova --domain default --password jitsinnovationlabs-openstack
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://192.168.1.150:8774/v2.1

openstack endpoint create --region RegionOne compute internal http://192.168.1.150:8774/v2.1

openstack endpoint create --region RegionOne compute admin http://192.168.1.150:8774/v2.1


crudini --set /etc/nova/nova.conf DEFAULT my_ip 192.168.1.150
crudini --set /etc/nova/nova.conf DEFAULT use_neutron true
crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
crudini --set /etc/nova/nova.conf DEFAULT enabled_apis osapi_compute,metadata
crudini --set /etc/nova/nova.conf DEFAULT transport_url rabbit://openstack:jitsinnovationlabs-rabbitmq@192.168.1.150

crudini --set /etc/nova/nova.conf api_database connection mysql+pymysql://nova:jitsinnovationlabs-mysqldb@192.168.1.150/nova_api
crudini --set /etc/nova/nova.conf database connection mysql+pymysql://nova:jitsinnovationlabs-mysqldb@192.168.1.150/nova
crudini --set /etc/nova/nova.conf api auth_strategy keystone
#crudini --set /etc/nova/nova.conf api connection  mysql+pymysql://nova:jitsinnovationlabs-mysqldb@192.168.1.150/nova

crudini --set /etc/nova/nova.conf keystone_authtoken www_authenticate_uri http://192.168.1.150:5000/
crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://192.168.1.150:5000/
crudini --set /etc/nova/nova.conf keystone_authtoken memcached_servers 192.168.1.150:11211
crudini --set /etc/nova/nova.conf keystone_authtoken auth_type password
crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_name Default
crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_name Default
crudini --set /etc/nova/nova.conf keystone_authtoken project_name service
crudini --set /etc/nova/nova.conf keystone_authtoken username nova
crudini --set /etc/nova/nova.conf keystone_authtoken password jitsinnovationlabs-openstack

crudini --set /etc/nova/nova.conf vnc enabled true 
crudini --set /etc/nova/nova.conf vnc server_listen \$my_ip
crudini --set /etc/nova/nova.conf vnc server_proxyclient_address \$my_ip

crudini --set /etc/nova/nova.conf glance api_servers http://192.168.1.150:9292

crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

crudini --set /etc/nova/nova.conf placement region_name RegionOne
crudini --set /etc/nova/nova.conf placement project_domain_name Default
crudini --set /etc/nova/nova.conf placement project_name service
crudini --set /etc/nova/nova.conf placement auth_type password
crudini --set /etc/nova/nova.conf placement user_domain_name Default
crudini --set /etc/nova/nova.conf placement auth_url http://192.168.1.150:5000/v3
crudini --set /etc/nova/nova.conf placement username placement
crudini --set /etc/nova/nova.conf placement password jitsinnovationlabs-openstack

crudini --set /etc/nova/nova.conf scheduler discover_hosts_in_cells_interval 300

crudini --set /etc/nova/nova.conf neutron url http://192.168.1.150:9696
crudini --set /etc/nova/nova.conf neutron auth_url http://192.168.1.150:5000
crudini --set /etc/nova/nova.conf neutron auth_type password
crudini --set /etc/nova/nova.conf neutron project_domain_name Default
crudini --set /etc/nova/nova.conf neutron user_domain_name Default
crudini --set /etc/nova/nova.conf neutron project_name service
crudini --set /etc/nova/nova.conf neutron username neutron
crudini --set /etc/nova/nova.conf neutron password jitsinnovationlabs-openstack
crudini --set /etc/nova/nova.conf neutron service_metadata_proxy True
crudini --set /etc/nova/nova.conf neutron metadata_proxy_shared_secret jitsinnovationlabs-openstack



openstack subnet create subnet1 --network int_net \
--subnet-range 10.0.0.0/24 --gateway 10.0.0.1 \
--dns-nameserver 192.168.1.1