#!/bin/bash
IP_HOST="${IP_ADDRESS:-192.168.1.3}"
openstack project create --domain default --description "Service Project" service
openstack project list
echo "create [glance] user in [service] project"
openstack user create --domain default --project service --password servicepassword glance
echo "add [glance] user in [admin] role"
openstack role add --project service --user glance admin
echo "create service entry for [glance]"
openstack service create --name glance --description "OpenStack Image service" image
echo "create endpoint for [glance] (public)"
openstack endpoint create --region RegionOne image public http://$IP_HOST:9292
echo "create endpoint for [glance] (internal)"
openstack endpoint create --region RegionOne image internal http://$IP_HOST:9292
echo "create endpoint for [glance] (admin)"
openstack endpoint create --region RegionOne image admin http://$IP_HOST:9292
echo "create [nova] user in [service] project"
openstack user create --domain default --project service --password servicepassword nova
echo "add [nova] user in [admin] role"
openstack role add --project service --user nova admin
echo "create [placement] user in [service] project"
openstack user create --domain default --project service --password servicepassword placement
echo "add [placement] user in [admin] role"
openstack role add --project service --user placement admin
echo "create service entry for [nova]"
openstack service create --name nova --description "OpenStack Compute service" compute
echo "create service entry for [placement]"
openstack service create --name placement --description "OpenStack Compute Placement service" placement
echo "create endpoint for [nova] (public)"
openstack endpoint create --region RegionOne compute public http://$IP_HOST:8774/v2.1/%\(tenant_id\)s
echo "create endpoint for [nova] (internal)"
openstack endpoint create --region RegionOne compute internal http://$IP_HOST:8774/v2.1/%\(tenant_id\)s
echo "create endpoint for [nova] (admin)"
openstack endpoint create --region RegionOne compute admin http://$IP_HOST:8774/v2.1/%\(tenant_id\)s
echo "create endpoint for [placement] (public)"
openstack endpoint create --region RegionOne placement public http://$IP_HOST:8778
echo "create endpoint for [placement] (internal)"
openstack endpoint create --region RegionOne placement internal http://$IP_HOST:8778
echo "create endpoint for [placement] (admin)"
openstack endpoint create --region RegionOne placement admin http://$IP_HOST:8778
echo "create [neutron] user in [service] project"
openstack user create --domain default --project service --password servicepassword neutron
echo "add [neutron] user in [admin] role"
openstack role add --project service --user neutron admin
echo "create service entry for [neutron]"
openstack service create --name neutron --description "OpenStack Networking service" network
echo "create endpoint for [neutron] (public)"
openstack endpoint create --region RegionOne network public http://$IP_HOST:9696
echo "create endpoint for [neutron] (internal)"
openstack endpoint create --region RegionOne network internal http://$IP_HOST:9696
echo "create endpoint for [neutron] (admin)"
openstack endpoint create --region RegionOne network admin http://$IP_HOST:9696
echo "create [cinder] user in [service] project "
openstack user create --domain default --project service --password servicepassword cinder
echo "add [cinder] user in [admin] role "
openstack role add --project service --user cinder admin
echo "create service entry for [cinder] "
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
echo "create endpoint for [cinder] (public) "
openstack endpoint create --region RegionOne volumev3 public http://$IP_HOST:8776/v3/%\(tenant_id\)s
echo "create endpoint for [cinder] (internal) "
openstack endpoint create --region RegionOne volumev3 internal http://$IP_HOST:8776/v3/%\(tenant_id\)s
echo "create endpoint for [cinder] (admin) "
openstack endpoint create --region RegionOne volumev3 admin http://$IP_HOST:8776/v3/%\(tenant_id\)s