FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install glance python3-openstackclient apache2 libapache2-mod-wsgi-py3 python3-oauth2client python3-pymysql git python3-pip

RUN git clone https://github.com/openstack/glance.git -b stable/wallaby
RUN pip3 install -r glance/requirements.txt && pip3 install -r glance/test-requirements.txt


RUN mv /etc/glance/glance-api.conf /etc/glance/glance-api.conf.org
COPY glance-api.conf /etc/glance/glance-api.conf

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 9292

CMD ["/usr/bin/init.sh"]
