FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install keystone python3-openstackclient apache2 libpq-dev libapache2-mod-wsgi-py3 python3-oauth2client python3-pymysql git python3-pip

RUN rm -rf /etc/keystone/keystone.conf && rm -rf /etc/apache2/apache2.conf
COPY keystone.conf /etc/keystone/keystone.conf
COPY apache2.conf /etc/apache2/apache2.conf

RUN git clone https://github.com/openstack/keystone.git -b stable/wallaby
RUN pip3 install -r keystone/requirements.txt && pip3 install -r keystone/test-requirements.txt

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 5000

# CMD ["/init.sh", "/usr/sbin/apachectl", "-DFOREGROUND"]
CMD ["/usr/bin/init.sh"]
