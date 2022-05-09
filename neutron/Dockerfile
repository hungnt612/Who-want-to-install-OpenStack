FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent python3-neutronclient

# RUN git clone https://github.com/openstack/nova.git -b stable/wallaby
COPY neutron /neutron
RUN pip3 install -r neutron/requirements.txt && pip3 install -r neutron/test-requirements.txt

#Replace nova config

RUN mv /etc/neutron/neutron.conf /etc/neutron/neutron.conf.org
COPY neutron.conf /etc/neutron/neutron.conf


RUN chmod 640 /etc/neutron/neutron.conf

RUN chgrp neutron /etc/neutron/neutron.conf


RUN mv /etc/placement/placement.conf /etc/placement/placement.conf.org
COPY placement.conf /etc/placement/placement.conf

RUN chmod 640 /etc/placement/placement.conf
RUN chgrp nova /etc/placement/placement.conf


COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
# EXPOSE 5000

CMD ["/usr/bin/init.sh"]