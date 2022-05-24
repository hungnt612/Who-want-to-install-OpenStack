#!/bin/bash
IP_HOST="${IP_ADDRESS:-localhost}"
echo "hihi"
echo $IP_HOST
INTERFACE_NAME='br-ex'

echo "sed -i 's/IP_ADDRESS/$IP_HOST/g' /etc/neutron/metadata_agent.ini" &&
sed 's+IP_ADDRESS+'"$IP_HOST+" /etc/neutron/metadata_agent.ini.example > /etc/neutron/metadata_agent.ini &&
chmod 640 /etc/neutron/metadata_agent.ini && chgrp neutron /etc/neutron/metadata_agent.ini &&
echo "sed -i 's/IP_ADDRESS/$IP_HOST/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini" &&
sed 's+IP_ADDRESS+'"$IP_HOST+" /etc/neutron/plugins/ml2/linuxbridge_agent.ini.example > /etc/neutron/plugins/ml2/linuxbridge_agent.ini.2 &&
# chmod 640 /etc/neutron/plugins/ml2/linuxbridge_agent.ini && chgrp neutron /etc/neutron/plugins/ml2/linuxbridge_agent.ini &&
echo "sed -i 's/INTERFACE_NAME/$INTERFACE_NAME/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini" &&
sed 's+IP_ADDRESS+'"$INTERFACE_NAME+" /etc/neutron/plugins/ml2/linuxbridge_agent.ini.2 > /etc/neutron/plugins/ml2/linuxbridge_agent.ini &&
chmod 640 /etc/neutron/plugins/ml2/linuxbridge_agent.ini && chgrp neutron /etc/neutron/plugins/ml2/linuxbridge_agent.ini.2 &&
filename=/etc/neutron/plugin.ini
if [ -f "$filename" ];
then
    echo "$filename has found."
else
    echo "ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini" &&
    ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini 
fi
echo 'eutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head' &&
su -s /bin/bash neutron -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head" &&
echo 'start service' && echo 'hehe' > /var/log/neutron/test.txt &&
# for service in server l3-agent dhcp-agent metadata-agent linuxbridge-agent; do
# service neutron-$service restart 
# done
service neutron-server restart &&
service neutron-l3-agent restart &&
service neutron-dhcp-agent restart &&
service neutron-metadata-agent restart &&
service neutron-linuxbridge-agent restart &&
tail -f /var/log/neutron/*