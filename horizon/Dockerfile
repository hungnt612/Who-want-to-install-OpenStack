FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install openstack-dashboard python3-openstackclient apache2 libpq-dev libapache2-mod-wsgi-py3 python3-oauth2client python3-pymysql git python3-pip

RUN rm -rf /etc/openstack-dashboard/local_settings.py && rm -rf /etc/apache2/apache2.conf
COPY local_settings.py.example /etc/openstack-dashboard/local_settings.py.example
COPY apache2.conf /etc/apache2/apache2.conf

COPY horizon /horizon
RUN pip3 install -r horizon/requirements.txt && pip3 install -r horizon/test-requirements.txt

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 80

# CMD ["/init.sh", "/usr/sbin/apachectl", "-DFOREGROUND"]
CMD ["/usr/bin/init.sh"]