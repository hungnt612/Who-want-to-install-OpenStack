#!/bin/bash

IP_HOST="${IP_ADDRESS:-192.168.1.3}"
echo "hihi"
echo $IP_HOST


echo "sed -i 's/IP_ADDRESS/$IP_HOST/g' /etc/cinder/cinder.conf" &&
sed 's+IP_ADDRESS+'"$IP_HOST+" /etc/cinder/cinder.conf.example > /etc/cinder/cinder.conf &&
chmod 640 /etc/cinder/cinder.conf &&
chgrp cinder /etc/cinder/cinder.conf &&
echo "cinder-manage db sync" &&
su -s /bin/bash cinder -c "cinder-manage db sync" &&
service cinder-api start &&
service cinder-scheduler start &&
echo "cinder started" > /var/log/cinder/test.txt &&
tail -f /var/log/cinder/*