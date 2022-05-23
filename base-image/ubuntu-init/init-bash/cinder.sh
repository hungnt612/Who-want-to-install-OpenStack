#!/bin/bash
IP_HOST="${IP_ADDRESS:-192.168.1.3}"

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