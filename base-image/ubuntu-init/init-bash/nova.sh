#!/bin/bash
IP_HOST="${IP_ADDRESS:-192.168.1.3}"

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