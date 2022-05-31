#!/bin/bash
grubby --update-kernel=ALL --args="nvme_core.default_ps_max_latency_us=5000"
sudo useradd -d /home/cephuser -m cephuser
echo "cephuser ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cephuser
sudo chmod 0440 /etc/sudoers.d/cephuser
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
echo "init"
dnf update -y

dnf config-manager --set-enabled powertools

dnf install -y wget  git vim

dnf install -y network-scripts

dnf install -y python3 lvm2

echo "config hosts"
echo "127.0.0.1 localhost `hostname`" > /etc/hosts
echo "192.168.1.150 controller" >> /etc/hosts
echo "192.168.1.160 compute01" >> /etc/hosts
echo "192.168.1.170 compute02" >> /etc/hosts

echo "config network ip static"
nmcli conn modify eno2 ipv4.addresses 192.168.1.160/24 ipv4.gateway 192.168.1.1 ipv4.method manual
nmcli con mod eno2 ipv4.dns "1.1.1.1 192.168.1.1 8.8.8.8 8.8.4.4"
nmcli con mod eno2 autoconnect yes

nmcli conn modify eno1 ipv4.addresses 192.168.10.150/24 ipv4.method manual
nmcli con mod eno1 autoconnect yes

echo "install docker"
dnf -y remove podman runc
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
dnf --enablerepo=docker-ce-stable -y install docker-ce
systemctl enable --now docker
docker version
sleep 6
reboot






for NODE in node01 node02 node03
do
    if [ ! ${NODE} = "node01" ]
    then
        scp /etc/ceph/ceph.conf ${NODE}:/etc/ceph/ceph.conf
        scp /etc/ceph/ceph.client.admin.keyring ${NODE}:/etc/ceph
        scp /var/lib/ceph/bootstrap-osd/ceph.keyring ${NODE}:/var/lib/ceph/bootstrap-osd
    fi
    ssh $NODE \
    "chown ceph. /etc/ceph/ceph.* /var/lib/ceph/bootstrap-osd/*; \
    parted --script /dev/nvme0n1 'mklabel mbr'; \
    parted --script /dev/nvme0n1 "mkpart primary 0% 100%"; \
    ceph-volume lvm create --data /dev/nvme0n1"
done 



# create new
NFS_CORE_PARAM {
    # disable NLM
    Enable_NLM = false;
    # disable RQUOTA (not suported on CephFS)
    Enable_RQUOTA = false;
    # NFS protocol
    Protocols = 4;
}
EXPORT_DEFAULTS {
    # default access mode
    Access_Type = RW;
}
EXPORT {
    # uniq ID
    Export_Id = 101;
    # mount path of CephFS
    Path = "/mnt/ceph-mount";
    FSAL {
        name = CEPH;
        # hostname or IP address of this Node
        hostname="192.168.1.150";
    }
    # setting for root Squash
    Squash="No_root_squash";
    # NFSv4 Pseudo path
    Pseudo="/vfs_ceph";
    # allowed security options
    SecType = "sys";
}
LOG {
    # default log level
    Default_Log_Level = WARN;
}



ceph orch apply mon --placement="controller,compute01,compute02"