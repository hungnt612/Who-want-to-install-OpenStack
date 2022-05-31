crudini --set /etc/nova/nova.conf DEFAULT enabled_apis osapi_compute,metadata
crudini --set /etc/nova/nova.conf DEFAULT transport_url rabbit://openstack:jitsinnovationlabs-rabbitmq@192.168.1.150
crudini --set /etc/nova/nova.conf DEFAULT my_ip 192.168.1.150
crudini --set /etc/nova/nova.conf DEFAULT use_neutron true
crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
crudini --set /etc/nova/nova.conf DEFAULT vif_plugging_is_fatal True
crudini --set /etc/nova/nova.conf DEFAULT vif_plugging_timeout 300

crudini --set /etc/nova/nova.conf api_database connection mysql+pymysql://nova:jitsinnovationlabs-mysqldb@192.168.1.150/nova_api

crudini --set /etc/nova/nova.conf database connection mysql+pymysql://nova:jitsinnovationlabs-mysqldb@192.168.1.150/nova

crudini --set /etc/nova/nova.conf api auth_strategy keystone

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
crudini --set /etc/nova/nova.conf vnc server_listen 0.0.0.0
crudini --set /etc/nova/nova.conf vnc server_proxyclient_address \$my_ip
crudini --set /etc/nova/nova.conf vnc novncproxy_base_url http://192.168.1.150:6080/vnc_auto.html

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

crudini --set /etc/nova/nova.conf libvirt virt_type  $(count=$(egrep -c '(vmx|svm)' /proc/cpuinfo); if [ $count -eq 0 ];then   echo "qemu"; else   echo "kvm"; fi)
