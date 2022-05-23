FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent python3-neutronclient libpq-dev libapache2-mod-wsgi-py3 python3-oauth2client python3-pymysql git python3-pip

# RUN git clone https://github.com/openstack/nova.git -b stable/wallaby
COPY neutron /neutron
RUN pip3 install -r neutron/requirements.txt && pip3 install -r neutron/test-requirements.txt

#Replace nova config

RUN mv /etc/neutron/neutron.conf /etc/neutron/neutron.conf.org
COPY neutron.conf /etc/neutron/neutron.conf

RUN mv /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini.org
COPY l3_agent.ini /etc/neutron/l3_agent.ini


RUN mv /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.org
COPY dhcp_agent.ini /etc/neutron/dhcp_agent.ini


RUN mv /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.org
COPY metadata_agent.ini.example /etc/neutron/metadata_agent.ini.example


RUN mv /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.org
COPY ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini


RUN mv /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.org
COPY linuxbridge_agent.ini.example /etc/neutron/plugins/ml2/linuxbridge_agent.ini.example


# RUN mv /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.org
COPY dnsmasq-neutron.conf /etc/neutron/dnsmasq-neutron.conf

RUN chmod 640 /etc/neutron/dnsmasq-neutron.conf

RUN chgrp neutron /etc/neutron/dnsmasq-neutron.conf

RUN chmod 640 /etc/neutron/neutron.conf

RUN chgrp neutron /etc/neutron/neutron.conf

RUN chmod 640 /etc/neutron/l3_agent.ini

RUN chgrp neutron /etc/neutron/l3_agent.ini

RUN chmod 640 /etc/neutron/dhcp_agent.ini

RUN chgrp neutron /etc/neutron/dhcp_agent.ini

RUN chmod 640 /etc/neutron/plugins/ml2/ml2_conf.ini

RUN chgrp neutron /etc/neutron/plugins/ml2/ml2_conf.ini

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 9696

CMD ["/usr/bin/init.sh"]
