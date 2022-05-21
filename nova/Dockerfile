FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install nova-api nova-conductor nova-scheduler nova-novncproxy python3-novaclient git python3-pip nova-compute nova-compute-kvm \
    && apt -y install qemu-kvm libvirt-daemon-system libvirt-daemon virtinst bridge-utils libosinfo-bin libguestfs-tools virt-top qemu-system-data

# RUN git clone https://github.com/openstack/nova.git -b stable/wallaby
COPY nova /nova
RUN pip3 install -r nova/requirements.txt && pip3 install -r nova/test-requirements.txt

#Replace nova config

RUN mv /etc/nova/nova.conf /etc/nova/nova.conf.org
COPY nova.conf.example /etc/nova/nova.conf.example

# RUN chmod 777 /etc/nova/nova.conf
# RUN chgrp nova /etc/nova/nova.conf

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 6080 8774 8775

CMD ["/usr/bin/init.sh"]