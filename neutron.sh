mysql -uroot -pjitsinnovationlabs-mysqldb -e "CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'192.168.1.150' IDENTIFIED BY 'jitsinnovationlabs-mysqldb';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'controller' IDENTIFIED BY 'jitsinnovationlabs-mysqldb'; 
FLUSH PRIVILEGES;"


openstack user create neutron --domain default --password jitsinnovationlabs-openstack

openstack role add --project service --user neutron admin

openstack service create --name neutron --description "OpenStack Compute" network

openstack endpoint create --region RegionOne network public http://192.168.1.150:9696

openstack endpoint create --region RegionOne network internal http://192.168.1.150:9696

openstack endpoint create --region RegionOne network admin http://192.168.1.150:9696



crudini --set  /etc/neutron/neutron.conf DEFAULT core_plugin ml2
crudini --set  /etc/neutron/neutron.conf DEFAULT service_plugins router
crudini --set  /etc/neutron/neutron.conf DEFAULT transport_url rabbit://openstack:jitsinnovationlabs-rabbitmq@192.168.1.150
crudini --set  /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
crudini --set  /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_status_changes True
crudini --set  /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_data_changes True 
crudini --set  /etc/neutron/neutron.conf DEFAULT dhcp_agent_notification True
crudini --set  /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True

crudini --set  /etc/neutron/neutron.conf database connection  mysql+pymysql://neutron:jitsinnovationlabs-mysqldb@192.168.1.150/neutron

crudini --set  /etc/neutron/neutron.conf keystone_authtoken www_authenticate_uri http://192.168.1.150:5000
crudini --set  /etc/neutron/neutron.conf keystone_authtoken auth_url http://192.168.1.150:5000
crudini --set  /etc/neutron/neutron.conf keystone_authtoken memcached_servers 192.168.1.150:11211
crudini --set  /etc/neutron/neutron.conf keystone_authtoken auth_type password
crudini --set  /etc/neutron/neutron.conf keystone_authtoken project_domain_name default
crudini --set  /etc/neutron/neutron.conf keystone_authtoken user_domain_name default
crudini --set  /etc/neutron/neutron.conf keystone_authtoken project_name service
crudini --set  /etc/neutron/neutron.conf keystone_authtoken username neutron
crudini --set  /etc/neutron/neutron.conf keystone_authtoken password jitsinnovationlabs-openstack

crudini --set /etc/neutron/neutron.conf nova auth_url http://192.168.1.150:5000
crudini --set /etc/neutron/neutron.conf nova auth_type password
crudini --set /etc/neutron/neutron.conf nova project_domain_name Default
crudini --set /etc/neutron/neutron.conf nova user_domain_name Default
crudini --set /etc/neutron/neutron.conf nova region_name RegionOne
crudini --set /etc/neutron/neutron.conf nova project_name service
crudini --set /etc/neutron/neutron.conf nova username nova
crudini --set /etc/neutron/neutron.conf nova password jitsinnovationlabs-openstack

crudini --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp


crudini --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_host 192.168.1.150
crudini --set /etc/neutron/metadata_agent.ini DEFAULT metadata_proxy_shared_secret jitsinnovationlabs-openstack
crudini --set /etc/neutron/metadata_agent.ini DEFAULT memcache_servers 192.168.1.150:11211


crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan,gre,vxlan
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types vxlan
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 extension_drivers port_security      
    
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks physnet1

crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_vxlan vni_ranges 1:1000

 crudini --set /etc/nova/nova.conf DEFAULT use_neutron True
crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver

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





crudini --set  /etc/neutron/neutron.conf DEFAULT core_plugin ml2
crudini --set  /etc/neutron/neutron.conf DEFAULT service_plugins router
crudini --set  /etc/neutron/neutron.conf DEFAULT transport_url rabbit://openstack:jitsinnovationlabs-rabbitmq@192.168.1.150
crudini --set  /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
crudini --set  /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True

crudini --set  /etc/neutron/neutron.conf keystone_authtoken www_authenticate_uri http://192.168.1.150:5000
crudini --set  /etc/neutron/neutron.conf keystone_authtoken auth_url http://192.168.1.150:5000
crudini --set  /etc/neutron/neutron.conf keystone_authtoken memcached_servers 192.168.1.150:11211
crudini --set  /etc/neutron/neutron.conf keystone_authtoken auth_type password
crudini --set  /etc/neutron/neutron.conf keystone_authtoken project_domain_name default
crudini --set  /etc/neutron/neutron.conf keystone_authtoken user_domain_name default
crudini --set  /etc/neutron/neutron.conf keystone_authtoken project_name service
crudini --set  /etc/neutron/neutron.conf keystone_authtoken username neutron
crudini --set  /etc/neutron/neutron.conf keystone_authtoken password jitsinnovationlabs-openstack

crudini --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp


crudini --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_host 192.168.1.150
crudini --set /etc/neutron/metadata_agent.ini DEFAULT metadata_proxy_shared_secret jitsinnovationlabs-openstack
crudini --set /etc/neutron/metadata_agent.ini DEFAULT memcache_servers 192.168.1.150:11211



crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup firewall_driver openvswitch
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup enable_security_group true
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup enable_ipset true

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini ovs bridge_mappings physnet1:br-eno1
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini ovs local_ip 192.168.1.150

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini agent tunnel_types vxlan
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini agent prevent_arp_spoofing True



crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins router
crudini --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True
crudini --set /etc/neutron/neutron.conf DEFAULT transport_url rabbit://openstack:jitsinnovationlabs-rabbitmq@192.168.1.150

crudini --set /etc/neutron/neutron.conf keystone_authtoken www_authenticate_uri http://192.168.1.150:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://192.168.1.150:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken memcached_servers 192.168.1.150:11211
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_type password
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_name Default
crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_name Default
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service
crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron
crudini --set /etc/neutron/neutron.conf keystone_authtoken password jitsinnovationlabs-openstack

crudini --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp






crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup firewall_driver openvswitch
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup enable_security_group true
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup enable_ipset true

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini ovs bridge_mappings physnet1:br-eno1
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini ovs local_ip 192.168.1.160

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini agent tunnel_types vxlan
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini agent prevent_arp_spoofing True




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

crudini --set /etc/nova/nova.conf DEFAULT use_neutron True
crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
crudini --set /etc/nova/nova.conf DEFAULT vif_plugging_is_fatal True
crudini --set /etc/nova/nova.conf DEFAULT vif_plugging_timeout 300



ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

systemctl enable --now openvswitch
 
ovs-vsctl add-br br-int

ovs-vsctl add-br br-eno1

ovs-vsctl add-port br-eno1 eno1

systemctl restart openstack-nova-compute
	
systemctl enable --now neutron-openvswitch-agent