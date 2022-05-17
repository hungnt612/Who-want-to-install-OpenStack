#!/bin/bash
IP_HOST="${IP_ADDRESS:-192.168.1.3}"

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