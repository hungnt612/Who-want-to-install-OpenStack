#!/bin/bash

HOST="${IP_ADDRESS:-localhost}"
#echo "hihi"
echo $HOST

echo "`date`"
# controller=${IP_ADDRESS}
ROOTPASSWD=${MYSQL_ROOT_PASSWORD}
SERVICEPASSWD= ${SERVICEPASSWD}

echo "Root password is ${MYSQL_ROOT_PASSWORD}"
echo "SERVICEPASSWD is  '${SERVICEPASSWD}'"

# check status of mariadb service
service mysql start

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup --"
    # pre configure
    echo "Configiring mariadb.."
    SECURE_MYSQL=$(expect -c "
    set timeout 10
    spawn mysql_secure_installation
    expect \"Enter current password for root (enter for none):\"
    send \"$MYSQL\r\"
    expect \"Set root password?\"
    send \"y\r\"
    expect \"New password:\"
    send \"$ROOTPASSWD\r\"
    expect \"Re-enter new password:\"
    send \"$ROOTPASSWD\r\"
    expect \"Remove anonymous users?\"
    send \"y\r\"
    expect \"Disallow root login remotely?\"
    send \"n\r\"
    expect \"Remove test database and access to it?\"
    send \"y\r\"
    expect \"Reload privilege tables now?\"
    send \"y\r\"
    expect eof
    ")

    echo "$SECURE_MYSQL"

    #Create user and password
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'root'@'%' IDENTIFIED BY '$ROOTPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
    mysql -uroot -p${ROOTPASSWD} -e "FLUSH PRIVILEGES"

    #   mysql -uroot -p${ROOTPASSWD} -e

    echo "CONFIG KEYSTONEEEEEEEEEEEEEEE"
    echo "Add a User and Database on MariaDB for Keystone."
    mysql -uroot -p${ROOTPASSWD} -e "create database keystone;"
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'keystone'@'%' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'keystone'@'localhost' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on keystone.* to keystone@'localhost' identified by  '${SERVICEPASSWD}';"
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on keystone.* to keystone@'%' identified by  '${SERVICEPASSWD}';"
    mysql -uroot -p${ROOTPASSWD} -e "flush privileges;"
    echo "Add a User and Database on MariaDB for Glance."
    mysql -uroot -p${ROOTPASSWD} -e "create database glance;"
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'glance'@'%' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'glance'@'localhost' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on glance.* to glance@'localhost' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on glance.* to glance@'%' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "flush privileges; "
    echo "Add a User and Database on MariaDB for Nova."
    mysql -uroot -p${ROOTPASSWD} -e "create database nova; "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'nova'@'%' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'nova'@'localhost' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'placement'@'%' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'placement'@'localhost' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on nova.* to nova@'localhost' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on nova.* to nova@'%' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "create database nova_api; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on nova_api.* to nova@'localhost' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on nova_api.* to nova@'%' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "create database nova_cell0; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on nova_cell0.* to nova@'localhost' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on nova_cell0.* to nova@'%' identified by  '${SERVICEPASSWD}';"
    mysql -uroot -p${ROOTPASSWD} -e "create database placement; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on placement.* to placement@'localhost' identified by  '${SERVICEPASSWD}';"
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on placement.* to placement@'%' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "flush privileges;"
    echo " Add a User and Database on MariaDB for Neutron."
    mysql -uroot -p${ROOTPASSWD} -e "create database neutron_ml2; "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'neutron'@'%' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'neutron'@'localhost' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on neutron_ml2.* to neutron@'localhost' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on neutron_ml2.* to neutron@'%' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "flush privileges;"
    echo "Add a User and Database on MariaDB for Cinder."
    mysql -uroot -p${ROOTPASSWD} -e "create database cinder;"
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'cinder'@'%' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "CREATE USER 'cinder'@'localhost' IDENTIFIED BY '$SERVICEPASSWD' "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on cinder.* to cinder@'localhost' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "grant all privileges on cinder.* to cinder@'%' identified by  '${SERVICEPASSWD}'; "
    mysql -uroot -p${ROOTPASSWD} -e "flush privileges;"
    echo "Init db done"
    echo "--------------------------------"
    tail -f /var/log/mysql/*
else
    echo "-- Not first container startup --"
    tail -f /var/log/mysql/*
fi