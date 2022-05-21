#!/bin/bash
IP_HOST="${IP_ADDRESS:-192.168.1.3}"

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
