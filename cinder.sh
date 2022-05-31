crudini --set /etc/cinder/cinder.conf DEFAULT rpc_backend rabbit
crudini --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone
crudini --set /etc/cinder/cinder.conf DEFAULT my_ip 192.168.1.150
crudini --set /etc/cinder/cinder.conf DEFAULT control_exchange cinder
crudini --set /etc/cinder/cinder.conf DEFAULT enable_v3_api True
crudini --set /etc/cinder/cinder.conf DEFAULT osapi_volume_listen  \$my_ip
crudini --set /etc/cinder/cinder.conf DEFAULT control_exchange cinder
crudini --set /etc/cinder/cinder.conf DEFAULT glance_api_servers http://192.168.1.150:9292
crudini --set /etc/cinder/cinder.conf DEFAULT enabled_backends ceph
crudini --set /etc/cinder/cinder.conf DEFAULT transport_url rabbit://openstack:jitsinnovationlabs-rabbitmq@192.168.1.150
crudini --set /etc/cinder/cinder.conf DEFAULT state_path /var/lib/cinder


crudini --set /etc/cinder/cinder.conf database connection  mysql+pymysql://cinder:jitsinnovationlabs-mysqldb@192.168.1.150/cinder

crudini --set /etc/cinder/cinder.conf keystone_authtoken www_authenticate_uri http://192.168.1.150:5000
crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://192.168.1.150:5000
crudini --set /etc/cinder/cinder.conf keystone_authtoken memcached_servers 192.168.1.150:11211
crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_type password
crudini --set /etc/cinder/cinder.conf keystone_authtoken project_domain_name Default
crudini --set /etc/cinder/cinder.conf keystone_authtoken user_domain_name Default
crudini --set /etc/cinder/cinder.conf keystone_authtoken project_name service
crudini --set /etc/cinder/cinder.conf keystone_authtoken username cinder
crudini --set /etc/cinder/cinder.conf keystone_authtoken password jitsinnovationlabs-openstack

crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_host 192.168.1.150
crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_port 5672
crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_password jitsinnovationlabs-openstack

crudini --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lib/cinder/tmp

crudini --set /etc/cinder/cinder.conf oslo_messaging_notifications driver messagingv2


crudini --set /etc/cinder/cinder.conf lvm volume_driver cinder.volume.drivers.rbd.RBDDriver
crudini --set /etc/cinder/cinder.conf lvm volume_group cinder-volumes
crudini --set /etc/cinder/cinder.conf lvm target_protocol iscsi
crudini --set /etc/cinder/cinder.conf lvm target_helper lioadm
crudini --set /etc/cinder/cinder.conf lvm volumes_dir \$state_path/volumes
crudini --set /etc/cinder/cinder.conf lvm target_ip_address 192.168.1.150