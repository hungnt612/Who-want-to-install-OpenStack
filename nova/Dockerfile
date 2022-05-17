FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install nova-api nova-conductor nova-scheduler nova-novncproxy placement-api python3-novaclient git python3-pip nova-compute nova-compute-kvm \
    && apt -y install qemu-kvm libvirt-daemon-system libvirt-daemon virtinst bridge-utils libosinfo-bin libguestfs-tools virt-top nova-compute nova-compute-kvm qemu-system-data

# RUN git clone https://github.com/openstack/nova.git -b stable/wallaby
COPY nova /nova
RUN pip3 install -r nova/requirements.txt && pip3 install -r nova/test-requirements.txt

#Replace nova config

RUN mv /etc/nova/nova.conf /etc/nova/nova.conf.org
COPY nova.conf /etc/nova/nova.conf

RUN chmod 777 /etc/nova/nova.conf
RUN chgrp nova /etc/nova/nova.conf

RUN mv /etc/placement/placement.conf /etc/placement/placement.conf.org
COPY placement.conf /etc/placement/placement.conf

RUN chmod 777 /etc/placement/placement.conf
RUN chgrp nova /etc/placement/placement.conf


COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 5000 6080 8774 8778

CMD ["/usr/bin/init.sh"]