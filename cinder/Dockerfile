FROM hungnt612/ubuntu-focal:TZ-HCM

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt -y install software-properties-common \
    && add-apt-repository -y cloud-archive:wallaby \
    && apt update && apt -y upgrade \
    && apt -y install cinder-api cinder-scheduler cinder-volume python3-mysqldb python3-rtslib-fb python3-cinderclient libpq-dev python3-oauth2client python3-pymysql git python3-pip

# RUN rm -rf /etc/keystone/keystone.conf && rm -rf /etc/apache2/apache2.conf
# COPY keystone.conf /etc/keystone/keystone.conf
# COPY apache2.conf /etc/apache2/apache2.conf

# RUN git clone https://github.com/openstack/keystone.git -b stable/wallaby
COPY cinder /cinder
RUN pip3 install -r cinder/requirements.txt && pip3 install -r cinder/test-requirements.txt

RUN mv /etc/cinder/cinder.conf /etc/cinder/cinder.conf.org
COPY cinder.conf.example /etc/cinder/cinder.conf.example

COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh
EXPOSE 8776

# CMD ["/init.sh", "/usr/sbin/apachectl", "-DFOREGROUND"]
CMD ["/usr/bin/init.sh"]